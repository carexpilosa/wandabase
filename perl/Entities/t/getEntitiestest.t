#!/usr/bin/perl

use strict;
use warnings;

use Cwd;
my $dir = getcwd;
use lib getcwd . "/perl";

use CGI;
use DBI;
use DB_File;
use Data::Dumper;
use POSIX qw(strftime);
use JSON;

use DBConnect::PostConnect;
use DBConnect::GetConnect;
use Entities;
use Entities::Events;
use Entities::Members;
use Entities::Comments;


my $eventsHash = Entities::Events->getAllEventsAsHash();
warn "######################## Events ########################";
warn Dumper $eventsHash;

my $membersHash = Entities::Members->getAllMembersAsHash();
warn "######################## Members ########################";
warn Dumper $membersHash;

my $commentsHash = Entities::Comments->getAllCommentsAsHash();
warn "######################## Comments ########################";
warn Dumper $commentsHash;

1;
