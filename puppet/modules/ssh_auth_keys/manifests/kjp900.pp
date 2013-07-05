class ssh_auth_keys::kjp900 ($user = undef) {

	if $user {
		$my_user = $user
	} else {
		$my_user = root
	}

	# kjp900's public ssh key.
	ssh_authorized_key { "$my_user:kjp900":
		ensure => present,
		user => $my_user,
		type => rsa,
		key => "AAAAB3NzaC1yc2EAAAABIwAAAQEA20vkNfQqHhfOmyva41c5nj7wly5TJgDg65AmezBVNO28okg8d/G+YAtAD2Remcwzp/z4hOSSlUKM1LrE7Wqqz+nplSSPDfZLDJmk5grVjLKgMBfOxzmTxhrEXD4DM/m8TG8qfp+upgheVb3kzgllIaqB9v7i1Q2DWdl2rxWtQymWk+AZpA0kjkULv9bpeg1xhCMHBjcaDDnIR3ah0WWHUCioSbkpZ+BLQrmr9CiicEeIBi5BEaoLaNtoMYaNRIjFaeu9yGxDMsYuGdlDVfPLJfjgYI/xnHzt/6zwSy6CLQJ3PuFqkq5rmWXcec5KUlam4HUrpoRAUjgm/eMPe+NK7Q==",
	}

}
