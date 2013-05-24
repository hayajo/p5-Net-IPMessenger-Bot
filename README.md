# NAME

Net::IPMessenger::Bot - IPMessenger-Bot building framework

# SYNOPSIS

    #!/usr/bin/env perl
    use strict;
    use warnings;

    use Net::IPMessenger::Bot;
    use Sys::Hostname;

    my $bot = Net::IPMessenger::Bot->new(
        configure => {
            UserName  => 'ipmsg_bot',
            NickName  => 'ipmsg_bot',
            GroupName => 'bot',
            HostName  => hostname(),
        },
        on_message => sub {
            my $user = shift;
            "Hello " . $user->nickname;
        },
    );

    $bot->start;

# DESCRIPTION

Net::IPMessenger::Bot is an IPMessenger-Bot building framework.

# METHODS

[Net::IPMessenger::Bot](http://search.cpan.org/perldoc?Net::IPMessenger::Bot) implements following methods.

## new

    my $bot = Net::IPMessenger::Bot->new(
        configure => {
            UserName  => 'ipmsg_bot',
            NickName  => 'ipmsg_bot',
            GroupName => 'bot',
            HostName  => hostname(),
        },
        on_message => sub {
            my $user = shift;
            "Hello " . $user->nickname;
        },
    );

Construct a new [Net::IPMessenger::Bot](http://search.cpan.org/perldoc?Net::IPMessenger::Bot).

- configure

        configure => {
            UserName  => 'ipmsg_bot',
            NickName  => 'ipmsg_bot',
            GroupName => 'bot',
            HostName  => hostname(),
        },

    options for [Net::IPMessenger](http://search.cpan.org/perldoc?Net::IPMessenger)\#new.

- on\_message

        on_message => sub {
            my $user = shift;
            "Hello " . $user->nickname;
        }

    or

        on_message => [
            qr/hello/ => sub {
              my $user = shift;
              "Hello " . $user->nickname;
            },
            qr/goodbye/ => sub {
              my $user = shift;
              "Goodbye " . $user->nickname;
            },
        }

    register callback.

## start

    $bot->start;

start bot.

# AUTHOR

hayajo <hayajo@cpan.org>

# COPYRIGHT

Copyright 2013- hayajo

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[Net::IPMessenger](http://search.cpan.org/perldoc?Net::IPMessenger)
