#!/usr/bin/perl 

use strict;
use warnings;

use CGI;
use DBI;
use DB_File;
use Data::Dumper;
use POSIX qw(strftime);
use JSON;

my $page  = new CGI;

#print "Content-type: text/html \n\n";

my $rest_data; # = $page->header('application/json;charset=UTF-8');
#print $page->header('application/json');
# ------ Initialisierung des Datenzugriffs �ber DB_File ------
#my $file = "./books.data";
#my %data;
#my $db = tie %data, "DB_File", $file or die "err open $file: $!\n";

# ------ Pr�fen ob �ber den definierten Pfad auf den REST Service zugegriffen wurde ------
my $path_info = $ENV{ 'PATH_INFO' };
warn $path_info;
my ($type, $id);
if ($path_info =~ /^\/(.+)?\/(.*)$/) {
  $type = $1;
  $id = $2;
}


warn "TYPE = $type; id=$id";


#if( not $type eq 'bookdb' ){
#  exit;
#}

# ------ Zugriffsmethode ermitteln
my $request_method = $ENV{ 'REQUEST_METHOD' };
$rest_data .= "REQUEST_METHOD => $request_method\n";

if( $request_method eq 'GET' ) {
  $rest_data .= "GET";

  if ($type eq 'members' && $id eq 'all') {
    my $dsn = "DBI:mysql:database=wanderbase;host=localhost";
    my $dbh = DBI->connect($dsn, 'markus', 'markus');
    my $statement = <<EOT;
      SELECT id, username, password, gender, date_of_membership, is_admin, motto
        FROM members;
EOT
    my $query = $dbh->prepare($statement);
    $query->execute() or die $query->err_str;
    my %result;
    while (my ($id, $username, $password, $gender, $date_of_membership, $is_admin, $motto) =
      $query->fetchrow_array()) {
        warn "$id, $username, $password, $gender, $date_of_membership, $is_admin, $motto";
        $result{$id} = {
          username => $username,
          password => $password,
          gender => $gender, 
          date_of_membership => $date_of_membership, 
          is_admin => $is_admin, 
          motto => $motto
        }
    }
    $rest_data = to_json(\%result);
  } else {
    $rest_data = to_json({
      'ein' => 'test',
      'als' => 'hash',
      'meth' => 'GET'
    });
  }

  
  $rest_data = $page->header(
    -content_type => 'application/json;charset=UTF-8',
    -access_control_allow_origin => '*') . $rest_data;
  
} elsif ( $request_method eq 'POST' ) { # ----- Daten schreiben
    my $data = from_json($page->param( 'POSTDATA' ));
    $data->{'date_of_membership'} = strftime('%Y-%m-%d', localtime);
    warn "DATA => ".Data::Dumper::Dumper $data;
    my @bindValues;
    map {
      my $ret;
      if ($_ eq 'is_admin') {
        $ret = $data->{$_} && $data->{$_} eq 'on' ? 1 : 0;
      } elsif($_ eq 'motto') {
        $ret = $data->{$_} || '';
      } elsif($_ eq 'date_of_membership') {
        $ret = strftime('%Y-%m-%d', localtime);
      } else {
        $ret = $data->{$_};
      }
      push @bindValues, $ret;
    } ('username', 'password', 'gender', 'date_of_membership', 'is_admin', 'motto');


    my $dsn = "DBI:mysql:database=wanderbase;host=localhost";
    my $dbh = DBI->connect($dsn, 'markus', 'markus');
    my $statement = 'INSERT INTO members (
        username, password, gender, date_of_membership, is_admin, motto
      ) VALUES(?, ?, ?, ?, ?, ?)';
    my $sth = $dbh->prepare($statement);
    warn $statement . " => " . join ', ', @bindValues;
    my $success = $sth->execute(@bindValues);

    $data->{'success'} = $success;
    warn "DATA => ".Data::Dumper::Dumper $data;

    $rest_data = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*'
    ) . to_json($data);
    
    
} else {
  $rest_data = $page->header('text/html', '404 Not found') . $rest_data;
}
#$rest_data = $page->header('text/html') . "OK\n";
print $rest_data; # http Response ausgeben
