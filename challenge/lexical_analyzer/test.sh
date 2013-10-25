#!/bin/bash

cat input.in | ./lexanal.pl > output.out
diff output.out sample_output.out
