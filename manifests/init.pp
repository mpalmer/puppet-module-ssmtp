# Install and configure the sSMTP service on a machine.
#
# Attributes:
#
#  * `root` (string; optional; default `"postmaster"`)
#
#     The local username to map all mail generated from users with UIDs <
#     1000.  Useful so you don't have to manually map every system user to
#     some real user.
#
#  * `relayhost` (string; optional; default `"mail"`)
#
#     A name or address of the machine to forward all mail to.  This can be
#     a qualified or unqualified name (which will be used directly; no MX
#     record lookup is done), or an IPv4 address.
#
#  * `mailname` (string; optional; default `$::fqdn` fact)
#
#     The string to put into the RHS of all e-mails sent without a domain.
#     You will want to set this to a name that globally resolves (if your
#     machine's FQDN doesn't), because otherwise your mail will be rejected
#     by a lot of machines for having a non-existent sender domain.
#
#  * `allow_from_override (boolean; optional; default `true`)
#
#     Whether or not users can set their own arbitrary envelope `From`
#     value using the `-f` option.  You should set this to false if you do
#     not trust users on the machine to not forge the source of their mail
#     (and to be too stupid to know about `telnet mail 25`).
#
class ssmtp(
		$root                = "postmaster",
		$relayhost           = "mail",
		$mailname            = $::fqdn,
		$allow_from_override = true,
) {
	noop {
		"ssmtp/installed": ;
		"ssmtp/configured":
			require => Noop["ssmtp/installed"];
	}

	package { "ssmtp":
		before => Noop["ssmtp/installed"];
	}

	$ssmtp_root      = $root
	$ssmtp_relayhost = $relayhost
	$ssmtp_mailname  = $mailname
	$ssmtp_override  = $allow_from_override

	file { "/etc/ssmtp/ssmtp.conf":
		ensure  => file,
		content => template("ssmtp/etc/ssmtp/ssmtp.conf"),
		mode    => 0444,
		owner   => "root",
		group   => "root",
		require => Noop["ssmtp/installed"],
		before  => Noop["ssmtp/configured"],
	}

	bitfile { "/etc/ssmtp/revaliases":
		mode    => 0444,
		owner   => "root",
		group   => "root",
		require => Noop["ssmtp/installed"],
	}

	bitfile::bit { "revaliases header":
		path    => "/etc/ssmtp/revaliases",
		ordinal => 0,
		content => "# THIS FILE IS AUTOMATICALLY DISTRIBUTED BY PUPPET\n# ANY LOCAL CHANGES WILL BE OVERWRITTEN\n\n",
	}
}
