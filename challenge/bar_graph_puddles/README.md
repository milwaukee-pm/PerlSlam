Bar Graph Puddles
=================

Consider the following picture:

    8|            _ _
    7|           |7 7|_
    6|  _        |    6|
    5| |5|      _|     |
    4| | |    _|4      |
    3|_| |  _|3        |
    2|2  |_|2          |
    1|____1____________|
    0|0 1 2 3 4 5 6 7 8

In this picture we have walls of different heights. This picture is represented
by an array of integers, where the value at each index is the height of the
wall. The picture above is represented with an array as [2,5,1,2,3,4,7,7,6].

Now imagine it rains. How much water is going to be accumulated in puddles
between walls?

    8|            _ _
    7|           |   |_
    6|  _        |     |
    5| | |1 2 3 4|     |
    4| | |5 6 7|       |
    3|_| |8 9|         |
    2|   |A|           |
    1|_________________|
    0|0 1 2 3 4 5 6 7 8

We count volume in square blocks of 1X1. So in the picture above, everything to
the left of index 1 spills out. Water to the right of index 7 also spills out.
We are left with a puddle between 1 and 6 and the volume is 10.

Found at [I Failed a Twitter Interview](http://qandwhat.apps.runkite.com/i-failed-a-twitter-interview/)

