#!/bin/bash -x
set -e

make EXTRA_CFLAGS=' -DDEV_NAME=waterpump '
