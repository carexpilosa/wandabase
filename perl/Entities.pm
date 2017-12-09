package Entities;

use Data::Dumper;
use JSON;
use CGI;


sub new {
  my ($class) = (@_);
  my $self = {};
  return bless $self, $class;
}

sub sortedFieldNamesForPost {
  my ($self) = @_;
  my @fieldKeys = grep {
    $self->fieldHash()->{$_}->{'postdata'}
  } keys(%{$self->fieldHash()});
  my @ret = (
    sort {
      $self->fieldHash()->{$a}->{'postorder'}
        <=> $self->fieldHash()->{$b}->{'postorder'}
    } @fieldKeys
  );
  return \@ret;
}

sub sortedFieldNamesForGet {
  my ($self) = @_;
  my @fieldKeys = grep {
    $self->fieldHash()->{$_}->{'getdata'}
  } keys(%{$self->fieldHash()});
  my @ret = (
    sort {
      $self->fieldHash()->{$a}->{'getorder'}
        <=> $self->fieldHash()->{$b}->{'getorder'}
    } @fieldKeys
  );
  return \@ret;
}

sub tokenIsValid {
  my $token = shift;
  my $page  = new CGI;
  my $dsn = "DBI:mysql:database=wanderbase;host=localhost";
  my $dbh = DBI->connect($dsn, 'markus', 'markus', {'mysql_enable_utf8' => 1});

  $statement = <<EOT;
    SELECT token_created, CURRENT_TIMESTAMP,
      TIMESTAMPDIFF(SECOND, token_created, CURRENT_TIMESTAMP)
        FROM members WHERE token=?
EOT
  #warn $statement." => $token";
  my $query = $dbh->prepare($statement);
  $query->execute($token) or die $query->err_str;

  my $diff = $query->fetchrow_hashref()
    ->{'TIMESTAMPDIFF(SECOND, token_created, CURRENT_TIMESTAMP)'};
  return $diff && $diff =~ /^\d+$/ && $diff < 3600;
}

1;
