#!/usr/bin/env perl
package LexAnal;

use strict;
use warnings;

unless ( caller() ) {
	my $code = join( '', <> );
	print run($code);
}

sub run {
	my $code = shift;

	my @output;

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

	while (1) {
		my $token;

		# Reserved Word
		if ( $code =~ m/\G\s*(begin|end|require|def|class|if|while|else|elsif|for|return|and|or)/gc ) {
			$token = $1;
			push @output, 'Reserved Word: ' . $token . ' - ' . $res{$token};
		}

		# String
		elsif (
			$code =~ m/\G
				\s*
				(
					"              # starts with dblquote
					(?:
						[^"]       # any non-dblquote
						| (?<=\\)" # OR an escaped dblquote
					)+             # 1 or more of ^
					"              # end with dlbquote
				)
			/xgc
		  )
		{
			$token = $1;
			push @output, 'String: ' . $token;
		}

		# Bad String
		elsif ( $code =~ m/\G\s*(".+)/gc ) {
			$token = $1;
			push @output, 'Bad String: ' . $token;
		}

		# Comment
		elsif ( $code =~ m/\G\s*(#.+)/gc ) {
			$token = $1;
			push @output, 'Comment: ' . $token;
		}

		# Identifier
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
			push @output, 'Identifier: ' . $token;
		}

		# Operator
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
			push @output, 'Operator: ' . $token;
		}

		# Number
		elsif ( $code =~ m/\G\s*(\d+)/xgc ) {
			$token = $1;
			push @output, 'Number: ' . $token;
		}

		# End Token
		elsif ( $code =~ m/\G\s*(\?)/gc ) {
			$token = $1;
			push @output, 'End Token: ' . $token;
			last;
		}

		# ruh roh
		else {
			die "wtf? :(\n" . pos($code);
		}
	}
	return \@output;
}

1;

