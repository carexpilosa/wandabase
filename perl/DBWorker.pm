package DBWorker;

use Data::Dumper;
use Config;

use strict;

sub connection {
  my $configHash = Config::configurationHash();
}

sub do {
  my ($dbh, $statement, $bindValueArray) = @_;
  my $query = $dbh->prepare($statement);
  my @result;
  $query->execute(@{$bindValueArray}) or die $query->err_str;
  while (my $res = $query->fetchrow_hashref()) {
    push @result, $res;
  }
  return \@result;
}

1;
