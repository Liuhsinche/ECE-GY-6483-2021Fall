#!/bin/sh
lli=${LLVMINTERP-lli}
exec $lli \
    /mnt/liuxzh/courses/ECE_GY_6483/REPO/src/T2/lab1/fir_prj/base/.autopilot/db/a.g.bc ${1+"$@"}
