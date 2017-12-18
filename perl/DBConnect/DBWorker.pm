package DBConnect::DBWorker;

use strict;
use warnings;

use Data::Dumper;
use Config;

sub connection {
  my $configHash = Config::configurationHash();
}

sub doGet {
  my ($pkg, $dbh, $statement, $bindValueArray) = @_;
  warn Dumper [$pkg, $dbh, $statement, $bindValueArray];
  my $query = $dbh->prepare($statement);
  $query->execute(@{$bindValueArray}) or die $query->err_str;
  my @result;
  while (my $res = $query->fetchrow_hashref()) {
    push @result, $res;
  }
  return \@result;
}

sub do {
  my ($pkg, $dbh, $statement, $bindValueArray) = @_;
  my $query = $dbh->prepare($statement);
  my $result;
  eval {
    $result = $query->execute(@{$bindValueArray}) or die $query->err_str;
  };
  return 'ERROR => '.$@ if $@;
  return $result;
}

sub doPost {
  my ($dbh, $statement, $bindValueArray) = @_;
  warn Dumper [$dbh, $statement, $bindValueArray];
  my $query = $dbh->prepare($statement);
  my $result = $query->execute(@{$bindValueArray}) or die $query->err_str;
  warn Dumper $result;
  
}

1;
