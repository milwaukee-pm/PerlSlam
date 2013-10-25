#!/usr/bin/env perl

use strict;
use warnings;
use File::Slurp 'slurp';

my $code = join( '', <> );

my %res = (
	"begin"   => 1,
	"end"     => 2,
	"require" => 3,
	"def"     => 4,
	"class"   => 5,
	"if"      => 6,
	"while"   => 7,
	"else"    => 8,
	"elsif"   => 9,
	"for"     => 10,
	"return"  => 11,
	"and"     => 12,
	"or"      => 13
);

my $token;
do {
	$token = undef;
	if ( $code =~ m/\G\s*(begin|end|require|def|class|if|while|else|elsif|for|return|and|or)/gc ) {
		$token = $1;
		print 'Reserved Word: ', $token, ' - ', $res{$token}, "\n";
	}
	elsif (
		$code =~ m/\G
		\s*
		(
			"
			(?:
				[^"]
				| (?<=\\)"
			)+
			"
		)
	/xgc
	  )
	{
		$token = $1;
		print 'String: ', $token, "\n";
	}
	elsif ( $code =~ m/\G\s*(#.+)/gc ) {
		$token = $1;
		print 'Comment: ', $token, "\n";
	}
	elsif (
		$code =~ m/\G
		\s*
		(
			[a-zA-Z_]
			[a-zA-Z0-9_]*
		)
	/xgc
	  )
	{
		$token = $1;
		print 'Identifier: ', $token, "\n";
	}
	elsif (
		$code =~ m/\G
		\s*
		(
			\+= | -= | \*= | \/= | <= | >= | == | != | ~= | ^= | %= | &= | \|= | \.\.\. | \.\. |
			[^
				\s
				\w
				\d
				\?
				"
				\#
			]
		)
	/xgc
	  )
	{
		$token = $1;
		print 'Operator: ', $token, "\n";
	}
	elsif (
		$code =~ m/\G
		\s*
		(
			\d+
		)
	/xgc
	  )
	{
		$token = $1;
		print 'Number: ', $token, "\n";
	}
	elsif (
		$code =~ m/\G
		\s*
		(
			"
			.+
		)
	/xgc
	  )
	{
		$token = $1;
		print 'Bad String: ', $token, "\n";
	}
	elsif (
		$code =~ m/\G
		\s*
		(\?)
	/xgc
	  )
	{
		print 'End Token: ', $1, "\n";
	}
	else {
		print "wtf? :(\n", pos($code), "\n";
	}

} while ( defined $token );

