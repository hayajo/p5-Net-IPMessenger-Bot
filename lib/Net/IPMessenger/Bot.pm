package Net::IPMessenger::Bot;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use parent qw/Net::IPMessenger/;

sub new {
    my ( $class, %args ) = @_;

    my $config = $args{config} || {};
    my $self = $class->SUPER::new(%$config);

    my $handler = $args{on};
    my $ev = Net::IPMessenger::Bot::EvenHandler->new( handler => $handler );

    $self->add_event_handler($ev);

    return $self;
}

sub start {
    my $self = shift;
    $self->join();
    while ( $self->recv() ) { }
}

sub join {
    my $self = shift;
    $self->send(
        {
            command => $self->messagecommand('BR_ENTRY')->set_broadcast,
            option  => $self->my_info,
        }
    );
}

{
    package Net::IPMessenger::Bot::EvenHandler;

    use parent qw/Net::IPMessenger::RecvEventHandler/;
    use Encode qw();

    sub new {
        my ($class, %args) = @_;

        $args{handler} = [ qr// => $args{handler} ]
            unless ( ref $args{handler} eq 'ARRAY' );

        my $self = shift->SUPER::new();
        $self->{handler} = $args{handler};

        return $self;
    }

    sub handle {
        my ( $self, $client ) = @_;

        return unless ( $self->{handler} );

        my $msg = Encode::decode( 'shiftjis', $client->get_message );
        my $res;

        while ( my ( $regex, $handler ) = splice( @{ $self->{handler} }, 0, 2 ) ) {
            if ( $msg =~ $regex ) {
                $res = $handler->($client);
                last;
            }
        }

        return $res;
    }

    sub SENDMSG {
        my ($self, $ipmsg, $client ) = @_;

        my $res = $self->handle($client);
        $ipmsg->send(
            {
                command  => $ipmsg->messagecommand('SENDMSG'),
                option   => $res,
                peeraddr => $client->peeraddr,
                peerport => $client->peerport,
            }
        ) if ( defined $res );
    }
}


1;
__END__

=encoding utf-8

=head1 NAME

Net::IPMessenger::Bot - Blah blah blah

=head1 SYNOPSIS

  use Net::IPMessenger::Bot;

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
