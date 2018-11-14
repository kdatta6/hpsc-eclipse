#!/bin/bash

# path of directory where the root filesystem is installed- SHOULD WE ASK THE USER?
sysRoot=${PWD}/sysroot

# path of directory where the required QEMU files are located
qemuFilesRoot=${PWD}/qemu_files

# install the cross-toolchain SDK in the path specified by the user (which is recorded as "toolChainRoot")
echo "Path of the root directory where the toolchains are installed:"
read toolChainRoot
echo "Name of the HPPS toolchain directory:"
read hppsToolchainDir
echo "Name of the GNU toolchain directory (for Arm Cortex-M and Cortex-R processors)?"
read baremetalToolchainDir

hppsToolchainRoot=${toolChainRoot}/${hppsToolchainDir}
baremetalToolchainRoot=${toolChainRoot}/${baremetalToolchainDir}

# clone the hpsc-baremetal git repo inside the eclipse-workspace directory,
# then add Eclipse-required files
cd eclipse-workspace
git clone -b hpsc https://github.com/ISI-apex/hpsc-baremetal.git
cd ../hpsc_baremetal_proj_files
cp -r .cproject .project .settings ../eclipse-workspace/hpsc-baremetal
cd ..

# list the old and new paths for the updated variables
old_eclipse=$(printf '%s\n' "/home/kdatta/Documents/eclipse_package/hpsc-eclipse/eclipse" | sed 's:[][\/.^$*]:\\&:g')
new_eclipse=$(printf '%s\n' "${PWD}/eclipse" | sed 's:[][\/.^$*]:\\&:g')
old_workspace=$(printf '%s\n' "/home/kdatta/Documents/eclipse_package/hpsc-eclipse/eclipse-workspace" | sed 's:[][\/.^$*]:\\&:g')
new_workspace=$(printf '%s\n' "${PWD}/eclipse-workspace" | sed 's:[][\/.^$*]:\\&:g')
old_sysroot=$(printf '%s\n' "/home/kdatta/Documents/eclipse_package/hpsc-eclipse/sysroot" | sed 's:[][\/.^$*]:\\&:g')
new_sysroot=$(printf '%s\n' "${sysRoot}" | sed 's:[][\/.^$*]:\\&:g')
old_hpps_toolchain=$(printf '%s\n' "/home/kdatta/Documents/eclipse_package/hpsc-eclipse/toolchains/hpps" | sed 's:[][\/.^$*]:\\&:g')
new_hpps_toolchain=$(printf '%s\n' "${hppsToolchainRoot}" | sed 's:[][\/.^$*]:\\&:g')
old_baremetal_toolchain=$(printf '%s\n' "/home/kdatta/Documents/eclipse_package/hpsc-eclipse/toolchains/non_hpps" | sed 's:[][\/.^$*]:\\&:g')
new_baremetal_toolchain=$(printf '%s\n' "${baremetalToolchainRoot}" | sed 's:[][\/.^$*]:\\&:g')

# update the contents of the "eclipse" and "eclipse-workspace" directories to reflect the new directory structure
find ./eclipse -type f -exec sed -i "s/${old_eclipse}/${new_eclipse}/g" {} +
find ./eclipse-workspace -type f -exec sed -i "s/${old_eclipse}/${new_eclipse}/g" {} +
find ./eclipse -type f -exec sed -i "s/${old_workspace}/${new_workspace}/g" {} +
find ./eclipse-workspace -type f -exec sed -i "s/${old_workspace}/${new_workspace}/g" {} +
find ./eclipse -type f -exec sed -i "s/${old_sysroot}/${new_sysroot}/g" {} +
find ./eclipse-workspace -type f -exec sed -i "s/${old_sysroot}/${new_sysroot}/g" {} +
find ./eclipse -type f -exec sed -i "s/${old_hpps_toolchain}/${new_hpps_toolchain}/g" {} +
find ./eclipse-workspace -type f -exec sed -i "s/${old_hpps_toolchain}/${new_hpps_toolchain}/g" {} +
find ./eclipse -type f -exec sed -i "s/${old_baremetal_toolchain}/${new_baremetal_toolchain}/g" {} +
find ./eclipse-workspace -type f -exec sed -i "s/${old_baremetal_toolchain}/${new_baremetal_toolchain}/g" {} +

# update the contents of the "eclipse-workspace" directory to reflect new directory structure and new toolchain path
#sed -i -e "s/${old_sysroot}/${new_sysroot}/g" ${PWD}/eclipse-workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.yocto.sdk.ide.1467355974.prefs
#sed -i -e "s/${old_hpps_toolchain}/${new_hpps_toolchain}/g" ${PWD}/eclipse-workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.yocto.sdk.ide.1467355974.prefs
#sed -i -e "s/${old_sysroot}/${new_sysroot}/g" ${PWD}/eclipse-workspace/simple_addition/.settings/org.eclipse.cdt.core.prefs
#sed -i -e "s/${old_hpps_toolchain}/${new_hpps_toolchain}/g" ${PWD}/eclipse-workspace/simple_addition/.settings/org.eclipse.cdt.core.prefs
#sed -i -e "s/${old_sysroot}/${new_sysroot}/g" ${PWD}/eclipse-workspace/simple_addition/.autotools
#sed -i -e "s/${old_sysroot}/${new_sysroot}/g" ${PWD}/eclipse-workspace/simple_addition/.gdbinit
#sed -i -e "s/${old_workspace}/${new_workspace}/g" ${PWD}/eclipse-workspace/simple_addition/simple_addition_gdb_aarch64-poky-linux.launch
#sed -i -e "s/${old_hpps_toolchain}/${new_hpps_toolchain}/g" ${PWD}/eclipse-workspace/simple_addition/simple_addition_gdb_aarch64-poky-linux.launch

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
