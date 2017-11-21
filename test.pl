#!/usr/bin/perl -w

use strict;

use DBI;
use DBD::mysql;
use Data::Dumper;

print "Content-Type: text/html\n\n";
print "Hello World";

my $dsn = "DBI:mysql:database=wanderbase;host=localhost";
my $dbh = DBI->connect($dsn, 'root', 'zM0dem');

my $sth = $dbh->prepare('SELECT * FROM members')
  or die "prepare statement failed: $dbh->errstr()";
$sth->execute();

while (my $ref = $sth->fetchrow_arrayref()) {
  warn Data::Dumper->Dump ($ref);
  print Data::Dumper->Dump ($ref);
}

