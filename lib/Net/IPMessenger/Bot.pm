package Net::IPMessenger::Bot;

use strict;
use warnings;
use 5.008_005;
our $VERSION = '0.01';

use Net::IPMessenger;
use Net::IPMessenger::Bot::EventHandler;

sub new {
    my ( $class, %args ) = @_;

    my $ipmsg   = Net::IPMessenger->new( %{ $args{configure} } );
    my $handler = Net::IPMessenger::Bot::EventHandler->new( handler => $args{on} );
    $ipmsg->add_event_handler($handler);

    my $self = bless { ipmsg => $ipmsg }, $class;
    $self->_set_signal_handlers;

    return $self;
}

sub start {
    my $self = shift;
    $self->join();
    while ( $self->{ipmsg}->recv() ) { }
}

sub join {
    my $self = shift;

    my $cmd = $self->{ipmsg}->messagecommand('BR_ENTRY')->set_broadcast;
    $self->{ipmsg}->send(
        {
            command => $cmd,
            option  => $self->{ipmsg}->my_info,
        }
    );
}

sub _set_signal_handlers {
    my $self = shift;
    $SIG{INT} = $SIG{TERM} = sub { $self->sighandle_INT() };
}

sub sighandle_INT {
    my $self = shift;

    my $cmd = $self->{ipmsg}->messagecommand('BR_EXIT')->set_broadcast;
    $self->{ipmsg}->send( { command => $cmd } );

    exit;
}


1;
__END__

=encoding utf-8

=head1 NAME

Net::IPMessenger::Bot - Blah blah blah

=head1 SYNOPSIS

  #!/usr/bin/env perl
  use strict;
  use warnings;

  use Net::IPMessenger::Bot;
  use Sys::Hostname ();

  my $bot = Net::IPMessenger::Bot->new(
      configure => {
          NickName  => 'ipmsg_bot',
          GroupName => 'bot',
          UserName  => __PACKAGE__,
          HostName  => Sys::Hostname::hostname(),
      },
      on => sub {
          my $client = shift;
          "Hello " . $client->nickname;
      },
  );

  $bot->start;

=head1 DESCRIPTION

Net::IPMessenger::Bot is

=head1 AUTHOR

hayajo E<lt>hayajo@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- hayajo

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
