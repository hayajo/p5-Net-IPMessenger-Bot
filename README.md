# NAME

Net::IPMessenger::Bot - Blah blah blah

# SYNOPSIS

    #!/usr/bin/env perl
    use strict;
    use warnings;

    use Net::IPMessenger::Bot;
    use Sys::Hostname ();

    my $bot = Net::IPMessenger::Bot->new(
        config => {
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

# DESCRIPTION

Net::IPMessenger::Bot is

# AUTHOR

hayajo <hayajo@cpan.org>

# COPYRIGHT

Copyright 2013- hayajo

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
