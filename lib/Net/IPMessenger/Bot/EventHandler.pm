package Net::IPMessenger::Bot::EventHandler;

use strict;
use warnings;

use parent qw/Net::IPMessenger::RecvEventHandler/;
use Encode qw();

sub new {
    my ($class, %args) = @_;

    my $self = shift->SUPER::new();

    $self->{handler}
        = ( ref $args{handler} eq 'ARRAY' )
        ? $args{handler}
        : [ qr// => $args{handler} ];

    return $self;
}

sub handle {
    my ( $self, $user ) = @_;

    return unless ( $self->{handler} );

    my $msg = Encode::decode( 'shiftjis', $user->get_message );
    my $res;

    while ( my ( $regex, $handler ) = splice( @{ $self->{handler} }, 0, 2 ) ) {
        if ( $msg =~ $regex ) {
            $res = $handler->($user);
            last;
        }
    }

    return $res;
}

sub SENDMSG {
    my ($self, $ipmsg, $user ) = @_;

    $ipmsg->message([]); #  clear cached-messages
    $self->SUPER::SENDMSG($ipmsg, $user);

    my $res = $self->handle($user);

    $ipmsg->send(
        {
            command  => $ipmsg->messagecommand('SENDMSG'),
            peeraddr => $user->peeraddr,
            peerport => $user->peerport,
            option   => $res,
        }
    ) if ( defined $res );
}

1;
