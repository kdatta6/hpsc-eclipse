AC_PREREQ(2.61)

# package version number (not shared library version)
# odd micro numbers indicate in-progress development
# even micro numbers indicate released versions
m4_define(hpps_simple_addition_version_major, 0)
m4_define(hpps_simple_addition_version_minor, 1)
m4_define(hpps_simple_addition_version_micro, 0)

m4_define([hpps_simple_addition_version],
          [hpps_simple_addition_version_major.hpps_simple_addition_version_minor.hpps_simple_addition_version_micro])
m4_define([hpps_simple_addition_api_version],
          [hpps_simple_addition_version_major.hpps_simple_addition_version_minor])

AC_INIT(hpps_simple_addition, hpps_simple_addition_version)
AM_INIT_AUTOMAKE
AC_CONFIG_HEADERS(config.h)

# Checks for programs.
AC_PROG_LIBTOOL
AM_PROG_CC_C_O
AC_PROG_INSTALL

AC_SUBST(hpps_simple_addition_CFLAGS)
AC_SUBST(hpps_simple_addition_LIBS)

AC_OUTPUT([
Makefile
src/Makefile
])

echo ""
echo "   hpps_simple_addition $VERSION"
echo "   ====================="
echo ""
echo "   To build the project, run \"make\""
echo ""
