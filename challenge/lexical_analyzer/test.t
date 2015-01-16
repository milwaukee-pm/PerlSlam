#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;    # tests => ?;

use LexAnal;
use File::Slurp 'read_file';

my $expected_r = read_file( 'sample_output.out', array_ref => 1, chomp => 1 );
my $output_r = LexAnal::run( scalar read_file('input.in') );

is_deeply( $output_r, $expected_r );

done_testing();

