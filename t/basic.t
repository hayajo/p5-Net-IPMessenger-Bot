use strict;
use Test::More;
use Net::EmptyPort qw/empty_port check_port/;
use Sys::Hostname;

use Net::IPMessenger::Bot;

subtest 'coderef' => sub {
    my $port = empty_port();

    my $pid = start_bot(
        port    => $port,
        handler => sub {
            my $user = shift;
            "Hello " . $user->nickname;
        },
    );

    my $user = generate_user();

    sendmsg(
        $user => 'hello',
        { peerport => $port },
    );
    my $recv = $user->recv;
    ok $recv;
    my $cmd = $user->messagecommand( $recv->command );
    like $recv->get_message, qr/Hello user/;

    kill 'INT', $pid;
    wait();
};

subtest 'arreyref' => sub {
    my $port = empty_port();

    my $pid = start_bot(
        port    => $port,
        handler => [
            qr/hello/ => sub {
                my $client = shift;
                "Hello " . $client->nickname;
            },
            qr/goodbye/ => sub {
                my $user = shift;
                "Goodbye " . $user->nickname;
            },
            qr// => sub {
                my $user = shift;
                "Unsupported Command: " . $user->get_message;
            },
        ],
    );

    my $user = generate_user();

    sendmsg(
        $user => 'hello',
        { peerport => $port },
    );
    my $recv = $user->recv;
    ok $recv;
    my $cmd = $user->messagecommand( $recv->command );
    like $recv->get_message, qr/Hello user/;

    sendmsg(
        $user => 'goodbye',
        { peerport => $port },
    );
    my $recv = $user->recv;
    ok $recv;
    like $recv->get_message, qr/Goodbye user/;

    sendmsg(
        $user => 'command',
        { peerport => $port },
    );
    my $recv = $user->recv;
    ok $recv;
    like $recv->get_message, qr/Unsupported Command: command/;

    kill 'INT', $pid;
    wait();
};

sub start_bot {
    my %args = @_;

    my $port    = $args{port}    or die;
    my $handler = $args{handler} or die;

    # parent
    if ( my $pid = fork ) {
        while ( !check_port( $port, 'udp' ) ) { sleep 1 }
        return $pid;
    }

    my $bot = Net::IPMessenger::Bot->new(
        configure => {
            Port     => $port,
            NickName => 'bot',
            UserName => 'bot',
            HostName => hostname(),
        },
        on => $handler,
    );

    $bot->start();
}

sub generate_user {
    Net::IPMessenger->new(
        Port     => empty_port(),
        NickName => 'user',
        UserName => 'user',
        HostName => hostname(),
    );
}

sub sendmsg {
    my ( $ipmsg, $message, $args ) = @_;
    $args ||= {};

    my $cmd = $ipmsg->messagecommand('SENDMSG');
    $ipmsg->send(
        {
            command  => $cmd,
            option   => $message || '',
            peeraddr => $args->{'peeraddr'} || '127.0.0.1',
            peerport => $args->{'peerport'} || 2425,
        }
    );
}

done_testing;
