package DBIx::SystemCatalog::Oracle;

use strict;
use DBI;
use DBIx::SystemCatalog;
use vars qw/$VERSION @ISA/;

$VERSION = '0.01';
@ISA = qw/DBIx::SystemCatalog/;

1;

sub schemas {
	my $obj = shift;

	my $d = $obj->{dbi}->selectall_arrayref("SELECT DISTINCT owner FROM (SELECT owner FROM all_tables UNION SELECT owner FROM all_views)");
	return () unless defined $d and @$d;
	return map { $_->[0] } @$d;
}

sub tables {
	my $obj = shift;

	my $d = $obj->{dbi}->selectall_arrayref("SELECT table_name FROM all_tables WHERE owner = ? UNION SELECT view_name FROM all_views WHERE owner = ?",{},$obj->{schema},$obj->{schema});
	return () unless defined $d and @$d;
	return map { $_->[0] } @$d;
}

sub table_type {
	my $obj = shift;
	my $table = shift;

	my $d = $obj->{dbi}->selectall_arrayref("SELECT 1 FROM all_tables WHERE table_name = ? AND owner = ?",{},$table,$obj->{schema});
	return SC_TYPE_TABLE if defined $d and @$d;
	
	$d = $obj->{dbi}->selectall_arrayref("SELECT 1 FROM all_views WHERE view_name = ? AND owner = ?",{},$table,$obj->{schema});
	return SC_TYPE_VIEW if defined $d and @$d;

	return SC_TYPE_UNKNOWN;
}

sub tables_with_types {
	my $obj = shift;

	my $d = $obj->{dbi}->selectall_arrayref("SELECT table_name,".SC_TYPE_TABLE." FROM all_tables WHERE owner = ? UNION SELECT view_name,".SC_TYPE_VIEW." FROM all_views WHERE owner = ?",{},$obj->{schema},$obj->{schema});
	return () unless defined $d and @$d;
	return map { { name => $_->[0], type => $_->[1] }; } @$d;
}

sub relationships {
	my $obj = shift;

	my $d = $obj->{dbi}->selectall_arrayref(q!SELECT first.table_name,second.table_name,first.constraint_name,second.constraint_name FROM all_constraints first, all_constraints second WHERE first.owner = :p1 AND first.constraint_type = 'R' AND first.r_constraint_name = second.constraint_name AND second.owner = :p1!,{},$obj->{schema});
	my $e = $obj->{dbi}->selectall_arrayref(q!SELECT constraint_name,table_name,column_name FROM all_cons_columns WHERE owner = ? ORDER BY constraint_name,position!,{},$obj->{schema});
	my %columns = ();
	if (defined $e and @$e) {
		for (@$e) {
			push @{$columns{$_->[0]}},
				{ table => $_->[1], column => $_->[2] };
		}
	}
	return map { { from_table => $_->[0], to_table => $_->[1], 
		name => $_->[2], from_columns => $columns{$_->[2]}, 
		to_columns => $columns{$_->[3]} } } @$d if defined $d and @$d;
	return ();
}
