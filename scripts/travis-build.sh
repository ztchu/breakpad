#!/bin/sh

set -ex

setup_env() {
  # Travis sets CC/CXX to the system toolchain, so our .travis.yml
  # exports USE_{CC,CXX} for this script to use.
  if test -n "$USE_CC"; then
      export CC=$USE_CC
  fi
  if test -n "$USE_CXX"; then
      export CXX=$USE_CXX
  fi
}

build() {
  ./configure
  # Use -jN for faster builds. Travis build machines under Docker
  # have a lot of cores, but resource limits will kill the build
  # if we try to use them all, so use at most 4.
  ncpus=$(getconf _NPROCESSORS_ONLN)
  jobs=$(($ncpus<4?$ncpus:4))
  make -j${jobs} check
}

main() {
  setup_env
  build
}

main "$@"
