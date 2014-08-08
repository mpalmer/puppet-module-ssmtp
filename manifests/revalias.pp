# Configure a single "reverse alias" for ssmtp.
#
# Attributes:
#
#  * `name` (*namevar*)
#
#     The local username to which this alias applies.
#
#  * `destination` (string; required)
#
#     The e-mail address to which mail should be delivered for the local
#     user specified.
#
#  * `relayhost` (string; optional; default `undef`)
#
#     Override the default relay host configured in the `ssmtp` class for
#     e-mails from this user.  This can be a bare name or IPv4 address, or
#     it can have an optional `:<port>` appended.
#
define ssmtp::revalias(
		$destination,
		$relayhost   = undef,
) {
	if $relayhost {
		$rh_part = ":${relayhost}"
	} else {
		$rh_part = ""
	}

	bitfile::bit { "revalias for ${name}":
		path    => "/etc/ssmtp/revaliases",
		content => "${name}:${destination}${rh_part}\n",
	}
}
