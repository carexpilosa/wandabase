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

  $statement = "SELECT token, token_created FROM members WHERE token=?";
  my $query = $dbh->prepare($statement);
  $query->execute() or die $query->err_str;

  while (my $res = $query->fetchrow_hashref()) {
    $result{$res->{'id'}} = $res;
  }
  $restData = Encode::encode_utf8(to_json(\%result));
  $restData = $page->header(
    -content_type => 'application/json;charset=UTF-8',
    -access_control_allow_origin => '*',
    -access_control_allow_methods => 'GET,HEAD,OPTIONS,POST,PUT',
    -access_control_allow_headers => 'Mode, Token, Origin, X-Requested-With, Content-Type, Accept',
    -content_type => 'application/json;charset=UTF-8',
    -status => '200 OK') . $restData;
  #warn Dumper $restData;
}

1;
