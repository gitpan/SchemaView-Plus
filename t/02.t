# test loading

BEGIN { $| = 1; print "1..2\n"; }
END { print "not ok 1\n" unless $loaded; }

use Math::Project qw/project/;

$loaded = 1;
print "ok 1\n";

# test one correct result of project()

my ($x,$y,$distance) = project (20,100,200,10,5,15);

if ($x == 42 and $y == 89 and $distance == 83) {
	print "ok 2\n";
} else {
	print "not ok 2\n";
}
