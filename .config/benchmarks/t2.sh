#!/bin/sh
echo "t2 - sequencial write read"
sysbench --threads=4 fileio --file-test-mode=seqwr run && rm test_file.*
