# test loading

BEGIN { $| = 1; print "1..2\n"; }
END { print "not ok 1\n" unless $loaded; }

use Data::RefSupport;

$loaded = 1;
print "ok 1\n";

my @a = Data::RefSupport::total_dereference(
	1, 2,
		[ 3, 4, 5,
			[ 6, 7,
				[ 8,
					[ 9, 10 ],
					[ 11, 12 ],
				],
			  13, 14, 
				[ 15 ],
			],
		  16,
		],
	17, 18,
		[ 19, 20 ],
	21, [ 22 ] );

my $i = 1;
for (@a) {
	last if $_ != $i;
	++$i;
}
print "not " if $i != 23;
print "ok 2\n";
