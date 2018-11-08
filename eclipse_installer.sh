#!/bin/bash

# path of directory where the root filesystem is installed
sysRoot=${PWD}/sysroot

# path of directory where the required QEMU files are located
qemuFilesRoot=${PWD}/qemu_files

# install the cross-toolchain SDK in the path specified by the user (which is recorded as "toolChainRoot")
echo "What is the path of the root directory where the toolchains are installed?"
read toolChainRoot
echo "What is the name of the HPPS toolchain directory?"
read hppsToolchainDir
echo "What is the name of the GNU toolchain directory (for Arm Cortex-M and Cortex-R processors)?"
read embeddedToolchainDir

hppsToolchainRoot=${toolChainRoot}/${hppsToolchainDir}
embeddedToolchainRoot=${toolChainRoot}/${embeddedToolchainDir}

# list the old and new paths
escaped_old_eclipse=$(printf '%s\n' "/home/kdatta/Documents/eclipse_package/eclipse_package/eclipse" | sed 's:[][\/.^$*]:\\&:g')
escaped_new_eclipse=$(printf '%s\n' "${PWD}/eclipse" | sed 's:[][\/.^$*]:\\&:g')
escaped_old_workspace=$(printf '%s\n' "/home/kdatta/Documents/eclipse_package/eclipse_package/eclipse-workspace" | sed 's:[][\/.^$*]:\\&:g')
escaped_new_workspace=$(printf '%s\n' "${PWD}/eclipse-workspace" | sed 's:[][\/.^$*]:\\&:g')
escaped_old_sysroot=$(printf '%s\n' "/home/kdatta/Documents/eclipse_package/eclipse_package/sysroot" | sed 's:[][\/.^$*]:\\&:g')
escaped_new_sysroot=$(printf '%s\n' "${sysRoot}" | sed 's:[][\/.^$*]:\\&:g')
escaped_old_hpps_toolchain=$(printf '%s\n' "/home/kdatta/Documents/eclipse_package/eclipse_package/sdk" | sed 's:[][\/.^$*]:\\&:g')
escaped_new_hpps_toolchain=$(printf '%s\n' "${hppsToolchainRoot}" | sed 's:[][\/.^$*]:\\&:g')

# update the contents of the "eclipse" directory to reflect new directory structure
sed -i -e "s/${escaped_old_workspace}/${escaped_new_workspace}/g" ${PWD}/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs
sed -i -e "s/${escaped_old_eclipse}/${escaped_new_eclipse}/g" ${PWD}/eclipse/p2/org.eclipse.equinox.p2.engine/profileRegistry/epp.package.cpp.profile/.data/.settings/org.eclipse.equinox.p2.metadata.repository.prefs

# update the contents of the "eclipse-workspace" directory to reflect new directory structure and new toolchain path
sed -i -e "s/${escaped_old_sysroot}/${escaped_new_sysroot}/g" ${PWD}/eclipse-workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.yocto.sdk.ide.1467355974.prefs
sed -i -e "s/${escaped_old_hpps_toolchain}/${escaped_new_hpps_toolchain}/g" ${PWD}/eclipse-workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.yocto.sdk.ide.1467355974.prefs
sed -i -e "s/${escaped_old_sysroot}/${escaped_new_sysroot}/g" ${PWD}/eclipse-workspace/simple_addition/.settings/org.eclipse.cdt.core.prefs
sed -i -e "s/${escaped_old_hpps_toolchain}/${escaped_new_hpps_toolchain}/g" ${PWD}/eclipse-workspace/simple_addition/.settings/org.eclipse.cdt.core.prefs
sed -i -e "s/${escaped_old_sysroot}/${escaped_new_sysroot}/g" ${PWD}/eclipse-workspace/simple_addition/.autotools
sed -i -e "s/${escaped_old_sysroot}/${escaped_new_sysroot}/g" ${PWD}/eclipse-workspace/simple_addition/.gdbinit
sed -i -e "s/${escaped_old_workspace}/${escaped_new_workspace}/g" ${PWD}/eclipse-workspace/simple_addition/simple_addition_gdb_aarch64-poky-linux.launch
sed -i -e "s/${escaped_old_hpps_toolchain}/${escaped_new_hpps_toolchain}/g" ${PWD}/eclipse-workspace/simple_addition/simple_addition_gdb_aarch64-poky-linux.launch

# set up Eclipse's External Tools Configurations to run QEMU
qemu_external_tools_config=${PWD}/eclipse-workspace/.metadata/.plugins/org.eclipse.debug.core/.launches/QEMU.launch

rm ${qemu_external_tools_config}
echo "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>" >> ${qemu_external_tools_config}
echo "<launchConfiguration type=\"org.eclipse.ui.externaltools.ProgramLaunchConfigurationType\">" >> ${qemu_external_tools_config}
echo "<stringAttribute key=\"org.eclipse.ui.externaltools.ATTR_LOCATION\" value=\""${qemuFilesRoot}/qemu-system-aarch64"\"/>" >> ${qemu_external_tools_config}
echo "<stringAttribute key=\"org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS\" value=\"-machine arm-generic-fdt -device loader,file=a53fsb.bin,addr=0xfffff000,cpu-num=0&#10;-nographic -serial mon:stdio -serial null&#10;-device loader,addr=0x6000000,file=hpsc-rootfs.cpio.gz.uboot&#10;-hw-dtb hpsc.dtb&#10;-device loader,file=bl31.elf,cpu-num=0&#10;-device loader,addr=0x4000000,file=linux-hpsc.dtb&#10;-device loader,addr=0x80000,file=Image&#10;-device loader,file=u-boot.elf&#10;-net nic -net nic -net nic -net nic,vlan=1 -net user,vlan=1,hostfwd=tcp:127.0.0.1:2345-10.0.2.15:2345,hostfwd=tcp:127.0.0.1:10022-10.0.2.15:22&#10;-device loader,file=m4resetA53.bin,cpu-num=10 -s\"/>" >> ${qemu_external_tools_config}
echo "<stringAttribute key=\"org.eclipse.ui.externaltools.ATTR_WORKING_DIRECTORY\" value=\""${qemuFilesRoot}"\"/>" >> ${qemu_external_tools_config}
echo "</launchConfiguration>" >> ${qemu_external_tools_config}

echo "Eclipse installation complete."
