#!/usr/bin/env bash

set -e

SRCDIR=${SRCDIR:-$PWD}
# The following assumes that REPO_URL looks like this: https://provider.com/username/packagename.git
PKGDIR="$(basename ${REPO_URL} .git)"

echo SRCDIR   : $SRCDIR
echo REPO_URL : $REPO_URL
echo PKGDIR   : $PKGDIR

git clone ${REPO_URL}

cd ${PKGDIR}

# show head commit for debugging
git log -n 1

###############################################################################
#

# for Semigroups package
if [[ -f prerequisites.sh ]]
then
  ./prerequisites.sh
fi

# build the package
cd ..
${GAP_HOME}/bin/BuildPackages.sh --with-gaproot=${GAP_HOME} --strict ${PKGDIR}
cd ${PKGDIR}


# set up a custom GAP root containing only this package, so that
# we can force GAP to load the correct version of this package
mkdir -p gaproot/pkg/
ln -s $PWD gaproot/pkg/

###############################################################################

# start GAP with custom GAP root, to ensure correct package version is loaded
GAP="${GAP_HOME}/bin/gap.sh -l $PWD/gaproot; --quitonbreak -q"

echo ""
echo "######################################################################"
echo "#"
echo "# TESTING WHETHER THE PACKAGE IS LOADABLE"
echo "#"
echo "######################################################################"
echo ""
$GAP <<GAPInput
Read("/home/gap/travis/ci.g");
SetInfoLevel(InfoPackageLoading,4);
if LoadPackage(LowercaseString(GetNameFromPackageInfo("PackageInfo.g"))) <> true then
    Print("PACKAGE IS NOT LOADABLE - TEST TERMINATED\n");
    FORCE_QUIT_GAP(1);
fi;
QUIT_GAP(0);
GAPInput

echo ""
echo "######################################################################"
echo "#"
echo "# TEST WITH DEFAULT PACKAGES, LOADED AT GAP STARTUP"
echo "#"
echo "######################################################################"
echo ""
$GAP <<GAPInput
Read("/home/gap/travis/ci.g");
if TestOnePackage(LowercaseString(GetNameFromPackageInfo("PackageInfo.g"))) <> true then
    FORCE_QUIT_GAP(1);
fi;
QUIT_GAP(0);
GAPInput

echo ""
echo "######################################################################"
echo "#"
echo "# TEST WITHOUT PACKAGES, EXCEPT REQUIRED BY GAP (using -A option)"
echo "#"
echo "######################################################################"
echo ""
$GAP -A <<GAPInput
Read("/home/gap/travis/ci.g");
if TestOnePackage(LowercaseString(GetNameFromPackageInfo("PackageInfo.g"))) <> true then
    FORCE_QUIT_GAP(1);
fi;
QUIT_GAP(0);
GAPInput

echo ""
echo "######################################################################"
echo "#"
echo "# TEST WITH ALL PACKAGES LOADED (using LoadAllPackages() command)"
echo "#"
echo "######################################################################"
echo ""
$GAP <<GAPInput
LoadAllPackages();
Read("/home/gap/travis/ci.g");
if TestOnePackage(LowercaseString(GetNameFromPackageInfo("PackageInfo.g"))) <> true then
    FORCE_QUIT_GAP(1);
fi;
QUIT_GAP(0);
GAPInput
