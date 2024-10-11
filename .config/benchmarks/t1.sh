#!/bin/sh
echo "t1 - random write read"
sysbench --threads=4 fileio --file-test-mode=rndwr prepare > /dev/null
sysbench --threads=4 fileio --file-test-mode=rndwr run 
rm test_file.* > /dev/null
