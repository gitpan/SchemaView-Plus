package Data::CompactDump;

use Exporter;
use vars qw(@ISA @EXPORT $VERSION);

@ISA = (Exporter);
@EXPORT = qw(compact);

$VERSION = '0.02';

=head1 NAME

Data::CompactDump - Perl extension for dumping xD structures in compact form

=head1 SYNOPSIS

	use Data::CompactDump qw/compact/;

	my @xd_structure = [ [ 1, 2 ], [ 3, [ 4, 5 ] ] ];
	my $dump = compact(@xd_structure);


=head1 DESCRIPTION

Module provides some functions for dumping xD structures (like Data::Dump or
Data::Dumper) but in compact form.

=head1 FUNCTIONS

=head2 compact xD

Make eval-compatible form of xD structure for saving and restoring data
(compact form)

	my @xd_structure = [ [ 1, 2 ], [ 3, [ 4, 5 ] ] ];
	my $dump = compact(@xd_structure);

=cut

sub compact {
        unless (defined (my $q = shift)) {
                return 'undef';
	} elsif (not ref $q) {
		if ($q =~ /^\d+$/) {
			return $q;
		} else {
			$q =~ s/\n/\\n/g;  $q =~ s/\r/\\r/g;  $q =~ s/'/\\'/g;
                	return "\'" . $q . "\'";
		}
        } elsif ((my $rr = ref $q) eq 'ARRAY') {
                return '[ ' . join(', ',map { compact($_); } @$q) . ' ]';  
        } elsif ($rr eq 'SCALAR') {   
                return '\\' . compact($$q);       
        } elsif ($rr eq 'HASH') {
                return  '{ ' . join(', ',map { $_ . ' => ' . compact($$q{$_}); }
				keys %$q) . ' }';
        } else { return '\?'; }
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

perl(1), svplus(1), Data::Dump(3), Data::Dumper(3).

=cut

