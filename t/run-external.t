#!/usr/bin/perl -w
#
# Tests via external command runs.

use warnings;
use strict;

use Test::More tests => 2;

SKIP: {
  require IPC::Open3;
  skip( "lack IPC::Open3 to test with", 1 ) if $@;

  local $SIG{PIPE} = sub { diag "unexpected SIGPIPE received" };
  local $SIG{CHLD} = 'IGNORE';

  eval {
    # this should not hang, however...
    local $SIG{ALRM} = sub { die "alarm\n" };
    alarm 30;

    # scalar filehandles caused much grief, so using barewords
    my $child_pid = IPC::Open3::open3( \*WRITE_FH, \*READ_FH, \*ERR_FH,
      qw(perl -Iblib/lib -MAcme::EdError -e warn stderr) );

    my $err_output = do { local $/; <ERR_FH> };
    chomp($err_output);
    is( $err_output, '?', 'check warn output from subprocess' );

    close(WRITE_FH);
    close(READ_FH);
    close(ERR_FH);
    waitpid( $child_pid, 0 );

    alarm 0;
  };
  diag("Eval for warn output caught: $@") if $@;

  eval {
    # this should not hang, however...
    local $SIG{ALRM} = sub { die "alarm\n" };
    alarm 30;

    # scalar filehandles caused much grief, so using barewords
    my $child_pid = IPC::Open3::open3( \*WRITE_FH, \*READ_FH, \*ERR_FH,
      qw(perl -Iblib/lib -MAcme::EdError -e die stderr) );

    my $err_output = do { local $/; <ERR_FH> };
    chomp($err_output);
    is( $err_output, '?', 'check die output from subprocess' );

    close(WRITE_FH);
    close(READ_FH);
    close(ERR_FH);
    waitpid( $child_pid, 0 );

    alarm 0;
  };
  diag("Eval for die output caught: $@") if $@;
}
