
class fix-etc-bashrc {
	# It is obscene that a distribution like RHEL should be sourcing
	# /etc/profile.d/* in non-login shells.  That includes shell
	# scripts you fools!  You don't need to source /etc/profile.d/*
	# after login - the environment has already been setup and inherited!
	# Argh!

	exec { "fix-etc-bashrc":
		path => "/usr/bin:/bin",
		command => "sed -i -e '\\:for i in /etc/profile\\.d/\\*\\.sh; do: i \\\n# THIS IS SO WRONG\n//,/done/ s,^,#,' /etc/bashrc",
		unless => "grep '^#.*for i in /etc/profile\\.d/\\*\\.sh; do' /etc/bashrc",
	}
}


