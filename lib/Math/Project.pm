package Math::Project;

use strict;
use vars qw/$VERSION @ISA @EXPORT_OK/;
use Exporter;

$VERSION = '0.03';
@ISA = qw/Exporter/;
@EXPORT_OK = qw/project abscissa_project/;

=head1 NAME

Math::Project - Perl extension for computing intersection with upright line
through input point

=head1 SYNOPSIS

	use Math::Project qw/project/;

	my ($x,$y,$distance) = project ($x1, $y1, $x2, $y2, $xi, $yi);

=head1 DESCRIPTION

This module provides function project() for computing intersection with
upright line through input point [xi,yi]. You must specify points
[x1,y1] and [x2,y2] of straight line.

You can use list of imported functions or access functions via 
C<Math::Project::function> schema.

=head1 FUNCTIONS

=head2 project (x1, y1, x2, y2, xi, yi)

Computes intersection between straight line specified with [x1,y1] and [x2,y2]
and upright line through input point [xi,yi]. Return three items in list,
the first two are coordinates of intersection [xc,yc] and the third is distance
between intersection and input point.

	my ($x,$y,$distance) = project ($x1, $y1, $x2, $y2, $xi, $yi);

=head2 abscissa_project (x1, y1, x2, y2, xi, yi)

Same as project() but [x1,y1] and [x2,y2] determine abscissa.

	my ($x,$y,$distance) = abscissa_project ($x1, $y1, $x2, $y2,
		$xi, $yi);

=cut

sub _sign {
	my $x = shift;
	return -1 if $x < 0;
	return +1 if $x > 0;
	return 0;
}

sub _round {
	my $f = shift;
	return int ($f+0.5);
}

sub _project {
	my ($x1,$y1,$x2,$y2,$xi,$yi) = @_;

	return [ $x1,$y1,0 ] if $x1 == $xi and $y1 == $yi;
	return [ $x2,$y2,0 ] if $x2 == $xi and $y2 == $yi;
	return [ $x1,$y1,0 ] if $x1 == $x2 and $y1 == $y2;

	my $dx = $x2-$x1;  my $dy = $y2-$y1;

	my $l = sqrt($dx*$dx+$dy*$dy);
	my $b = sqrt(($xi-$x1)*($xi-$x1)+($yi-$y1)*($yi-$y1));
	my $c = sqrt(($xi-$x2)*($xi-$x2)+($yi-$y2)*($yi-$y2));
	my $a = ($b*$b-$c*$c+$l*$l)/(2*$l);
	my $d = sqrt($b*$b-$a*$a);

	my $xo = ($a/$l) * $dx;
	my $yo = ($a/$l) * $dy;

	my $abscissa = 0;
	++$abscissa if _sign($dx) == _sign($xo) and _sign($dy) == _sign($yo)
		and (abs($xo) < abs($dx) or abs($yo) < abs($dy));

	my @res = (_round($x1+$xo), _round($y1+$yo), _round(abs($d)), 
		$abscissa);

	return wantarray ? @res : \@res;
}

sub project {
	my @res = _project(@_);
	pop @res;  
	return wantarray ? @res : \@res;
}

sub abscissa_project {
	my @res = _project(@_);
	my $a = pop @res;
	return wantarray ? () : undef unless $a;
	return wantarray ? @res : \@res;
}

1;

__END__

=head1 VERSION

0.03

=head1 AUTHOR

(c) 2001 Milan Sorm, sorm@pef.mendelu.cz
at Faculty of Economics,
Mendel University of Agriculture and Forestry in Brno, Czech Republic.

This module was needed for making SchemaView Plus (C<svplus>) for adding
drag points to coord based connection method.

=head1 SEE ALSO

perl(1), svplus(1).

=cut

