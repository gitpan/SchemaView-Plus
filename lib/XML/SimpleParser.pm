package XML::SimpleParser;

use strict;
use vars qw/$VERSION/;
use Data::RefSupport qw/total_dereference/;
use IO::File;

$VERSION = '0.01';

=head1 NAME

XML::SimpleParser - Perl extension for XML parsing without external libraries

=head1 SYNOPSIS

	use XML::SimpleParse;

	my $parser = new XML::SimpleParser;

	my $tree = $parser->parse_file('example.xml');

=head1 DESCRIPTION

XML::Parser call Expat libraries and make many unneeded and slow things.
I need parser for reading XML documents with large tolerance to errors
and non-standard things. This is answer for question why I make yet another
XML parser.

=head1 THE XML::SIMPLEPARSER CLASS

=head2 new

Constructor create instance of XML::SimpleParser class. 

	my $parser = new XML::SimpleParser;

=cut

sub new {
	my $class = shift;
	my $obj = bless { }, $class;
	return $obj;
}

=head2 parse STRING

Parse STRING (XML) and return tree with XML document. Return undef when
exception occurs.

=cut

sub parse {
	my $obj = shift;
	my $data = join '',total_dereference(@_);

	return undef;
}

=head2 parse_file NAME

Parse file with filename NAME. If NAME is filehandle, parse its contents.
Return like parse().

=cut

sub parse_file {
	my $obj = shift;
	my $name = shift;

	return undef unless defined $name;
	my @lines = ();
	my $ioref;
	if (ref $name) {
		eval {
			$ioref = *{$name}{IO};
		};
		return undef if $@;
		@lines = <$ioref>;
	} else {
		return undef unless $ioref = new IO::File $name;
		@lines = <$ioref>;
		$ioref->close();
	}

	return $obj->parse(@lines);
}

1;

__END__

=head1 VERSION

0.01

=head1 AUTHOR

(c) 2001 Milan Sorm, sorm@pef.mendelu.cz
at Faculty of Economics,
Mendel University of Agriculture and Forestry in Brno, Czech Republic.

This module was needed for making SchemaView Plus (C<svplus>) for reading
and saving XML files (not total well-structured non-standard files must
be accepted too - e.g. Java XML packages results etc.).

=head1 SEE ALSO

perl(1), svplus(1), XML::Parser(3), XML::Dumper(3), IO::File(3).

=cut

