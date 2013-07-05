
# Hosts that can be ssh'd into.

class ssh {

	case $osfamily {
		RedHat: {
			$ssh_service = "sshd"
		}
		Debian: {
			$ssh_service = "ssh"
		}
		default: {
			$ssh_service = "sshd"
		}
	}

	package { 'openssh-server':
		ensure => present,
		before => File['/etc/ssh/sshd_config'],
	}

	file { '/etc/ssh/sshd_config':
		ensure => file,
		mode   => 600,
	}

	service { "$ssh_service":
		ensure     => running,
		enable     => true,
		hasrestart => true,
		hasstatus  => true,
		subscribe  => File['/etc/ssh/sshd_config'],
	}

	# The empty string is false, which leads to this inelegance.
	#host_keys { ["_", "_dsa_", "_ecdsa_", "_rsa_"]: }
	host_keys { ["_", "_dsa_", "_rsa_"]: }

}
