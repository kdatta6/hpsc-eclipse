AC_PREREQ(2.61)

# package version number (not shared library version)
# odd micro numbers indicate in-progress development
# even micro numbers indicate released versions
m4_define(simple_addition_version_major, 0)
m4_define(simple_addition_version_minor, 1)
m4_define(simple_addition_version_micro, 0)

m4_define([simple_addition_version],
          [simple_addition_version_major.simple_addition_version_minor.simple_addition_version_micro])
m4_define([simple_addition_api_version],
          [simple_addition_version_major.simple_addition_version_minor])

AC_INIT(simple_addition, simple_addition_version)
AM_INIT_AUTOMAKE
AC_CONFIG_HEADERS(config.h)

# Checks for programs.
AC_PROG_LIBTOOL
AM_PROG_CC_C_O
AC_PROG_INSTALL

AC_SUBST(simple_addition_CFLAGS)
AC_SUBST(simple_addition_LIBS)

AC_OUTPUT([
Makefile
src/Makefile
])

echo ""
echo "   simple_addition $VERSION"
echo "   ====================="
echo ""
echo "   To build the project, run \"make\""
echo ""
