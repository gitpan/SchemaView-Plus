package Data::RefSupport;

use strict;
use vars qw/$VERSION @ISA @EXPORT_OK/;
use Exporter;

$VERSION = '0.02';
@ISA = qw/Exporter/;
@EXPORT_OK = qw/total_dereference/;

=head1 NAME

Data::RefSupport - Perl extension for working with xD data structures (refs)

=head1 SYNOPSIS

	use Data::RefSupport qw/total_dereference/;

	my @xd_structure = [ [ 1, 2 ], [ 3, [ 4, 5 ] ] ];
	my @clean_array = total_dereference(@xd_structure);


=head1 DESCRIPTION

Module provides some functions for good work with xD data structures (refs).
E.g. total_dereference in SYNOPSIS has result

	( 1, 2, 3, 4, 5 )

=head1 FUNCTIONS

=head2 total_derefererence xD

Make one array from many xD arrays arguments

	my @xd_structure = [ [ 1, 2 ], [ 3, [ 4, 5 ] ] ];
	my @clean_array = total_dereference(@xd_structure);

=cut

sub total_dereference {
	my @array = @_;

	return map {
		ref $_ eq 'ARRAY' ? total_dereference(@$_) : $_
	} @array;
}

1;

__END__

=head1 VERSION

0.02

=head1 AUTHOR

(c) 2001 Milan Sorm, sorm@pef.mendelu.cz
at Faculty of Economics,
Mendel University of Agriculture and Forestry in Brno, Czech Republic.

This module was needed for making SchemaView Plus (C<svplus>).

=head1 SEE ALSO

perl(1), svplus(1).

=cut

