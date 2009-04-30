# Initial "does it load and perform basic operations" tests

use warnings;
use strict;

use Test::More 'no_plan';
#use Test::More tests => 6;

BEGIN { use_ok('Acme::EdError') }

ok( defined $Acme::EdError::VERSION, '$VERSION defined' );
diag "Version is $Acme::EdError::VERSION\n" if exists $ENV{'TEST_VERBOSE'};

# TODO figure out how to properly test the output!!

# expect to see two ? lines returned by following program
my $have_open3 = 0;
eval { require IPC::Open3; };
if ($@) {
  chomp $@;
  diag "IPC::Open3 failed to load: errno=$@\n";
} else {
  require IPC::Open3;
  $have_open3 = 1;
}

my ( $fh_write, $fh_read, $fh_error );
my $open_worked = 0;
#SKIP: {
#  skip 'no IPC::Open3 to run test with', 1 unless $have_open3;

#  if (
    ok(
      IPC::Open3::open3( $fh_write, $fh_read, $fh_error, 't/show-errors' ),
      'run t/show-errors with IPC::Open3'
    );
##   ) {
#    $open_worked = 1;
#  } else {
#    diag "failed to run t/show-errors: errno=$!\n";
#  }
#}

#SKIP: {
#  skip 't/show-errors failed to run', 2 unless $open_worked;

  my $warning = <$fh_error>;
  cmp_ok( $warning, 'eq', '?', 'check warn output' );

  my $error = <$fh_error>;
  cmp_ok( $error, 'eq', '?', 'check die output' );
#}
