package DBIx::SystemCatalog::Pg;

use strict;
use DBI;
use DBIx::SystemCatalog;
use vars qw/$VERSION @ISA/;

$VERSION = '0.01';
@ISA = qw/DBIx::SystemCatalog/;

1;

sub schemas {
	my $obj = shift;

	my $d = $obj->{dbi}->selectall_arrayref("SELECT tableowner FROM pg_tables UNION SELECT viewowner FROM pg_views");
	return () unless defined $d and @$d;
	return map { $_->[0] } @$d;
}

sub tables {
	my $obj = shift;

	my $d = $obj->{dbi}->selectall_arrayref("SELECT tablename FROM pg_tables WHERE tableowner = ? UNION SELECT viewname FROM pg_views WHERE viewowner = ?",{},$obj->{schema},$obj->{schema});
	return () unless defined $d and @$d;
	return map { $_->[0] } @$d;
}

sub table_type {
	my $obj = shift;
	my $table = shift;

	my $d = $obj->{dbi}->selectall_arrayref("SELECT 1 FROM pg_tables WHERE tablename = ? AND tableowner = ?",{},$table,$obj->{schema});
	return SC_TYPE_TABLE if defined $d and @$d;
	
	$d = $obj->{dbi}->selectall_arrayref("SELECT 1 FROM pg_views WHERE viewname = ? AND viewowner = ?",{},$table,$obj->{schema});
	return SC_TYPE_VIEW if defined $d and @$d;

	return SC_TYPE_UNKNOWN;
}

sub tables_with_types {
	my $obj = shift;
	my $d = $obj->{dbi}->selectall_arrayref("SELECT tablename,".SC_TYPE_TABLE." FROM pg_tables WHERE tableowner = ? UNION SELECT viewname,".SC_TYPE_VIEW." FROM pg_views WHERE viewowner = ?",{},$obj->{schema},$obj->{schema});
	return () unless defined $d and @$d;
	return map { { name => $_->[0], type => $_->[1] }; } @$d;
}
