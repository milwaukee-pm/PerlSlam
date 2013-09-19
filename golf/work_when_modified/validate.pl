#!/usr/bin/env perl

=head1 SYNOPSIS

  ./validate.pl my_answer.pl

=head1 DESCRIPTION

The challenge is to write a Perl program that will print out "perl" when it
executes.  The catch is that if any one character is modified, it must *still*
print "perl."  So modificiations include deleting, inserting, or replacing one
character.  Characters in this validation script simply include those you can
see on your American keyboard.

=cut

use strict;
use warnings;

use IO::All 'io';
use Capture::Tiny 'capture';

my $answer = 'perl';
my @chars  = (
	0 .. 9, 'a' .. 'z',    #
	split( '', '`~!@#$%^&*()-_+=[{]}|\;:\'",<.>/?' ),
);

my $program < io( $ARGV[0] );

$program =~ s/^#\!.*//g;    # remove shebang
$program =~ s/\s+$//;       # rid trailing ws

test($program);             # original

while ( $program =~ m/[^\s]/g ) {
	my $i = pos($program);
	next unless defined $i;
	$i--;

	my $test = $program;
	substr( $test, $i, 1, '' );    # delete char
	test($test);

	foreach my $c (@chars) {
		$test = $program;
		substr( $test, $i, 0, $c );    # insert char
		test($test);

		$test = $program;
		substr( $test, $i, 1, $c );    # replace char
		test($test);
	}
}

foreach my $c (@chars) {
	my $test = $program . $c;          # append char
	test($test);
}

print "WIN!\n";
my $size = length($program);
print "size: $size\n";

sub test {
	my $t = shift;

	#printf "testing: %s\n", $t;

	# /me is not sure the best way to check the answer
	# option 1) not reliable...
	#my ( $stdout, $stderr, @result ) = capture { eval $t };

	# option 2) slow...
	my ( $stdout, $stderr, @result ) = capture {
		system( 'perl', '-e', $t );
	};

	if (   !$stderr
		&& defined $stdout
		&& $stdout ne $answer )
	{
		die("FAIL! Output is $stdout for the following:\n$t\n");
	}
}

