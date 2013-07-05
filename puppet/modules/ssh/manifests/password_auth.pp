
class ssh::password_auth ($ensure = yes) {

	file_line { "sshd_config_password_auth_enable":
		path => "/etc/ssh/sshd_config",
		match => "^PasswordAuthentication ",
		line => "PasswordAuthentication $ensure",
		notify => Service["$ssh::ssh_service"],
	}

}
