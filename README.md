Configure an ssmtp service on a machine.

Not a lot to be done here.  You can install and configure ssmtp:

    class { "ssmtp":
        root                => "postmaster",
        relayhost           => "mail.example.com",
        mailname            => "example.com",
        allow_from_override => false,
    }

You can also configure "reverse aliases", which defines destination
addresses for specific local accounts:

    ssmtp::revalias { "root":
        destination => "someone@example.com",
        relayhost   => "mail.example.com",
    }

That's about it.  Not much to be done with ssmtp, really, it's quite
straightforward.

