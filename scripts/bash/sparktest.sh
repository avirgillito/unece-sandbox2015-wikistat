#!/bin/bash

pythondir=$(dirname $(cd "$( dirname "$0" )" && pwd))/python

spark-submit --master yarn-client ${pythondir}/sparktest.py 1>out 2>err
