#!/env/perl

use strict;
use DBI;
use DBD::mysql;
use Data::Dumper;

my $dsn = "DBI:mysql:database=wandabase;host=localhost";
my $dbh = DBI->connect($dsn, 'markus', 'markus');

my $sth = $dbh->prepare('SELECT * FROM members')
  or die "prepare statement failed: $dbh->errstr()";
$sth->execute();

while (my $ref = $sth->fetchrow_arrayref()) {
  print Data::Dumper->Dump ($ref);
}

