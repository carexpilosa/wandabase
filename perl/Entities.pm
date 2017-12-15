package Entities;

use strict;
use warnings;

use Data::Dumper;
use JSON;
use CGI;
use DBConnect::Connect;


sub new {
  my ($class) = (@_);
  my $self = {};
  return bless $self, $class;
}

sub sortedFieldNamesForPost {
  my ($pkg) = @_;
  my @fieldKeys = grep {
    $pkg->fieldHash()->{$_}->{'postdata'}
  } keys(%{$pkg->fieldHash()});
  my @ret = (
    sort {
      $pkg->fieldHash()->{$a}->{'postorder'}
        <=> $pkg->fieldHash()->{$b}->{'postorder'}
    } @fieldKeys
  );
  return \@ret;
}

sub sortedFieldNamesForGet {
  my ($pkg) = @_;
  my @fieldKeys = grep {
    $pkg->fieldHash()->{$_}->{'getdata'}
  } keys(%{$pkg->fieldHash()});
  my @ret = (
    sort {
      $pkg->fieldHash()->{$a}->{'getorder'}
        <=> $pkg->fieldHash()->{$b}->{'getorder'}
    } @fieldKeys
  );
  return \@ret;
}

sub tokenIsValid {
  my $token = shift;
  my $page  = new CGI;
  my $dbh = DBConnect::Connect::dbhandler();

  my $statement = <<EOT;
    SELECT token_created, CURRENT_TIMESTAMP,
      TIMESTAMPDIFF(SECOND, token_created, CURRENT_TIMESTAMP)
        FROM members WHERE token=?
EOT
  my $query = $dbh->prepare($statement);
  $query->execute($token) or die $query->err_str;

  my $res = $query->fetchrow_hashref();
  return 0 unless $res;
  my $diff = $res
    ->{'TIMESTAMPDIFF(SECOND, token_created, CURRENT_TIMESTAMP)'};
  return $diff && $diff =~ /^\d+$/ && $diff < 3600;
}

sub getMemberForValidToken {
  my ($self, $token) = @_;
  my $page  = new CGI;
  my $dbh = DBConnect::Connect::dbhandler();

  my $statement = <<EOT;
    SELECT id, username, TIMESTAMPDIFF(SECOND, token_created, CURRENT_TIMESTAMP)
      FROM members
        WHERE token=?
EOT

  my $query = $dbh->prepare($statement);
  $query->execute($token) or die $query->err_str;

  my $res = $query->fetchrow_hashref();
  return 0 unless $res;
  my $diff = $res
    ->{'TIMESTAMPDIFF(SECOND, token_created, CURRENT_TIMESTAMP)'};
  return $diff && $diff =~ /^\d+$/ && $diff < 3600
    ? $res : undef;
}

1;
