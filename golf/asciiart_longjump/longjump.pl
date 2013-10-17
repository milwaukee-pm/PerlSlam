#!/usr/bin/env perl

use strict;
use warnings;

use DDP;
use Curses;
use Term::Animation;
use Math::Trig;
use Algorithm::Line::Bresenham 'line';

my $angle   = 35;
my $speed   = 20;
my $bottom  = 33;
my $jump_at = 30;
my $gravity = 9.81;

my $distance = int( $speed * $speed * sin( deg2rad( 2 * $angle ) ) / $gravity * 2 );

my @points = ( [ 0, 0 ] );

foreach my $x ( 0 .. $distance ) {
	my $y = int( $x * tan( deg2rad($angle) ) - $gravity * $x**2 / ( 2 * $speed * cos( deg2rad($angle) ) )**2 );
	my @new_points = line( $points[-1][0], $points[-1][1] => $x, $y );
	shift @new_points;
	push @points, @new_points;
}

# full screen animation object
my $s = Term::Animation->new();

my @athlete_run = (
	q{
  O
 /|\/
  |
_/ \
    \
},
	q{
  O
  |_
  |
\/ \
   |
},
	q{
  O
  |
  |
  |>
 /
},
	q{
  O
 <|\_
  |
 / \
/  /
},
);

my @athlete_jump = (
	q{
 _O_/
/ |
  |/|
 /  /
/
},
	q{
 \O
  |
\_|
_/

},
	q{
  O//
  |
  |___
    \

},
	q{

  O__
  |___


},
	q{


  O_
 /__
   /
},
);

halfdelay(1);

my $runner = $s->new_entity(
	shape         => \@athlete_run,
	position      => [ 0, $bottom, 0 ],    # x, y, z
	callback_args => [ 1, 0, 0, 1 ],       # x, y, z, frame
	default_color => 'WHITE',
	auto_trans    => 1,
);
my $jumper;

while (1) {
	$s->animate();

	my ( $x, $y, $z ) = $runner->position();
	if ( $x == $jump_at ) {
		$runner->kill();
		$jumper = $s->new_entity(
			shape         => \@athlete_jump,
			position      => [ $jump_at, $bottom, 0 ],    # x, y, depth
			callback      => \&jump_cb,
			default_color => 'WHITE',
			auto_trans    => 1,
		);
	}

	# ask for user input, and wait a bit. exit our loop
	# if the user gives us a 'q'
	my $in = lc( getch() );
	if ( $in eq 'q' ) { last; }
}

sub jump_cb {
	my ( $entity, $anim ) = @_;

	my $i = $entity->callback_args() // 0;
	$entity->callback_args( ++$i );

	my $x = $points[$i][0] // $distance;
	my $y = $points[$i][1] // 0;
	my $z = 0;

	my $percent = int( $x / $distance * 100 );
	my $frame =
	    $percent < 10 ? 0
	  : $percent < 20 ? 1
	  : $percent < 30 ? 2
	  : $percent < 99 ? 3
	  :                 4;

	if ( $y < 0 ) {
		$y = 0;
		$x--;
	}
	$y = int( $bottom - $y );

	# return the absolute x,y,z coordinates to move to
	return ( $x + $jump_at, $y, $z, $frame );
}

