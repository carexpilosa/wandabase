package Entities;

use Data::Dumper;

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

1;
