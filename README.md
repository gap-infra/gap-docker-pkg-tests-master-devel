[![Build Status](https://travis-ci.org/gap-infra/gap-docker-pkg-tests-master-devel.svg?branch=master)](https://travis-ci.org/gap-infra/gap-docker-pkg-tests-master-devel)

# gap-docker-pkg-tests-master-devel

This repository is used to run standard tests for development
versions of GAP packages using the Docker container with GAP
from the tip of the master branch and packages from the archive
https://www.gap-system.org/pub/gap/gap4pkgs/packages-master.tar.gz.
This docker container is updated daily and is available on DockerHub:
https://hub.docker.com/r/gapsystem/gap-docker-master/.

This service provides an opportunity to test changes that have been
made in a GAP package but are not yet included into its official 
release, for their compatibility with the current development version
of GAP and with other GAP packages prepared for the next GAP release.

This test is run daily, and one can access test logs for each package at
https://travis-ci.org/gap-infra/gap-docker-pkg-tests-master-devel. 

To use this service, the package should have a `TestFile` component in
its `PackageInfo.g` to specify a short test (to run for no more than
several minutes) which may be used to check that a package works as
expected. Please see `?TestPackage`, `?Tests files for a GAP package` and
also `?TestDirectory` in GAP for more information. You can find a sample
setup in the example package at https://github.com/gap-packages/example.

To add a package to the test, please submit here an issue with the link
to the package source repository on GitHub. Alternatively, you may submit
a pull request to add an appropriate line to the list of packages at
https://github.com/gap-infra/gap-docker-pkg-tests-master-devel/blob/master/.travis.yml

The test will attempt to build packages that support the standard
`./configure; make` build procedure (possibly with `./autogen.sh`
prior to that). In case of special steps that should precede the 
build, add an executable `prerequsites.sh` script which will automate
those steps. An example of such script which clones `libsemigroups`
repository need to build the Semigroups package could be found at
https://github.com/gap-packages/Semigroups/blob/master/prerequisites.sh.

There are further tests of GAP packages in other settings. You can find all
of them in one place at https://github.com/gap-system/gap-distribution.
