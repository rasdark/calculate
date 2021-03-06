# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=(python{2_6,2_7})

inherit distutils-r1 eutils

SRC_URI="ftp://ftp.calculate-linux.org/calculate/source/calculate2/${PN}/${P}.tar.bz2
	http://mirror.yandex.ru/calculate/source/calculate2/${PN}/${P}.tar.bz2"

DESCRIPTION="Configuration utility for Linux services"
HOMEPAGE="http://www.calculate-linux.org/main/en/calculate2"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="calculate_nomail
calculate_nodhcp
calculate_noftp
calculate_nojabber
calculate_nonamed
calculate_nosamba
calculate_noproxy"

DEPEND="=sys-apps/calculate-lib-2.1.11-r5
	>=net-nds/openldap-2.3[-minimal]
	>=sys-auth/pam_ldap-180[ssl]
	>=sys-auth/nss_ldap-239
	!calculate_nosamba? (
		>=net-fs/samba-3.4.6[acl,client,cups,ldap,netapi,pam,server,smbclient]
		<net-fs/samba-4.0.0
	)
	!calculate_nomail? ( 
		|| ( <net-mail/dovecot-1.2.0[pop3d,ldap,pam,ssl]
			>=net-mail/dovecot-1.2.0[ldap,pam,ssl]
		)
		>=mail-filter/procmail-3.22
		dev-python/pymilter
		>=mail-mta/postfix-2.2[ldap,pam,ssl,sasl,dovecot-sasl]
	)
	!calculate_noftp? (
		|| ( <net-ftp/proftpd-1.3.3[-acl,ldap,ncurses,nls,pam,ssl,tcpd]
			>=net-ftp/proftpd-1.3.3[-acl,ident,ldap,ncurses,nls,pam,ssl,tcpd]
		)
	)
	!calculate_nojabber? (
		>=net-im/ejabberd-2.1.8[mod_pubsub]
		>=media-gfx/imagemagick-6.6
	)
	!calculate_nonamed? ( >=net-dns/bind-9.6.1_p1[sdb-ldap] )
	!calculate_noproxy? ( >=net-proxy/squid-3.0.14[ldap,pam,ssl] )
	!calculate_nodhcp? ( >=net-misc/dhcp-3.1.2_p1 )"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack "${A}"
	cd "${S}"

	# ftp .Trash-uid
	epatch "${FILESDIR}/calculate-server-2.1.16-ftp_trash.patch"

	# fix check ip
	epatch "${FILESDIR}/calculate-server-2.1.16-fix_ip_check.patch"

	# fix get ip
	epatch "${FILESDIR}/calculate-server-2.1.16-fix_get_ip.patch"

	# add win7 profile dir
	epatch "${FILESDIR}/calculate-server-2.1.16-win7_profile.patch"

	# fix work with calculate.env
	epatch "${FILESDIR}/calculate-server-2.1.16-fix_inienv.patch"

	# fix jabber tls
	epatch "${FILESDIR}/calculate-server-2.1.16-jabber_tls.patch"

	# fix empty ip
	epatch "${FILESDIR}/calculate-server-2.1.16-fix_empty_ip.patch"

	# add smtp auth
	epatch "${FILESDIR}/calculate-server-2.1.16-smtp_auth.patch"

	# add samba options for remote work distfiles
	epatch "${FILESDIR}/calculate-server-2.1.16-distfiles.patch"

	# support squid 3.2
	epatch "${FILESDIR}/calculate-server-2.1.16-fix_proxy.patch"

	# fix sasl config
	epatch "${FILESDIR}/calculate-server-2.1.16-fix_sasl_config.patch"

	# fix repl cron script
	epatch "${FILESDIR}/calculate-server-2.1.16-fix_replcron.patch"

	# fix mac address
	epatch "${FILESDIR}/calculate-server-2.1.16-mac_lower.patch"

	# fix dovecot conf
	epatch "${FILESDIR}/calculate-server-2.1.16-fix_dovecot.patch"
	
	# nt acl support off for share
	epatch "${FILESDIR}/calculate-server-2.1.16-nt_acl.patch"

	# discard obsolete squid option
	epatch "${FILESDIR}/calculate-server-2.1.16-fix_proxy2.patch"

	# add ipv4 squid option
	epatch "${FILESDIR}/calculate-server-2.1.16-squid_ipv4.patch"
}

pkg_postinst() {
	if [ -d /var/calculate/server-data/mail/imap ] || \
		[ -d /var/calculate/server-data/samba/win/profiles ] || \
		[ -d /var/calculate/server-data/samba/unix/profiles ] || \
		[ -d /var/calculate/server-data/samba/win/netlogon ];
	then
		ewarn "Data found in directories of previous version calculate-server"
	fi

	if [ -d /var/calculate/server-data/mail/imap ];
	then
		if ! [ -d /var/calculate/server-data/mail~ ];
		then
			if mv /var/calculate/server-data/mail/imap \
				/var/calculate/server-data/mail~ && \
				rmdir /var/calculate/server-data/mail && \
				mv /var/calculate/server-data/mail~ \
					/var/calculate/server-data/mail;
			then
				ewarn
				ewarn "Data from /var/calculate/server-data/mail/imap"
				ewarn "was moved to /var/calculate/server-data/mail"
				MAILUPDATE="TRUE"
			fi
		fi
		if ! [ "${MAILUPDATE}" == "TRUE" ];
		then
			eerror "Cannot move /var/calculate/server-data/mail/imap"
			eerror "Please manualy move /var/calculate/server-data/mail/imap"
			eerror "to /var/calculate/server-data/mail"
		fi
	fi

	if [ -d /var/calculate/server-data/samba/win/profiles ];
	then
		SAMBAUPDATE=""
		if ! [ -d /var/calculate/server-data/samba/profiles/win ];
		then
			if mkdir -p /var/calculate/server-data/samba/profiles && \
				mv  /var/calculate/server-data/samba/win/profiles \
					/var/calculate/server-data/samba/profiles/win;
			then
				ewarn
				ewarn "Data from /var/calculate/server-data/samba/win/profiles"
				ewarn "was moved to /var/calculate/server-data/samba/profiles/win"
				SAMBAUPDATE="TRUE"
			fi
		fi
		if ! [ "${SAMBAUPDATE}" == "TRUE" ];
		then
			eerror "Cannot move /var/calculate/server-data/samba/win/profiles"
			eerror "Please manualy move "
			eerror "/var/calculate/server-data/samba/win/profiles"
			eerror "to /var/calculate/server-data/samba/profiles/win"
		fi
	fi

	if [ -d /var/calculate/server-data/samba/unix/profiles ]; \
	then
		SAMBAUPDATE=""
		if ! [ -d /var/calculate/server-data/samba/profiles/unix ];
		then
			if mkdir -p /var/calculate/server-data/samba/profiles && \
				mv -f /var/calculate/server-data/samba/unix/profiles \
					/var/calculate/server-data/samba/profiles/unix;
			then
				rmdir /var/calculate/server-data/samba/unix
				ewarn
				ewarn "Data from /var/calculate/server-data/samba/unix/profiles"
				ewarn "was moved to /var/calculate/server-data/samba/profiles/unix"
				SAMBAUPDATE="TRUE"
			fi
		fi
		if ! [ "${SAMBAUPDATE}" == "TRUE" ];
		then
			eerror "Cannot move /var/calculate/server-data/samba/unix/profiles"
			eerror "Please manualy move "
			eerror "/var/calculate/server-data/samba/unix/profiles"
			eerror "to /var/calculate/server-data/samba/profiles/unix"
		fi
	fi

	if [ -d /var/calculate/server-data/samba/win/netlogon ];
	then
		SAMBAUPDATE=""
		if ! [ -d /var/calculate/server-data/samba/netlogon ];
		then
			if mv -f /var/calculate/server-data/samba/win/netlogon \
				/var/calculate/server-data/samba/netlogon;
			then
				rmdir /var/calculate/server-data/samba/win
				ewarn
				ewarn "Data form /var/calculate/server-data/samba/win/netlogon"
				ewarn "was moved to /var/calculate/server-data/samba/netlogon"
				SAMBAUPDATE="TRUE"
			fi
		fi
		if ! [ "${SAMBAUPDATE}" == "TRUE" ];
		then
			eerror "Cannot move /var/calculate/server-data/samba/win/netlogon"
			eerror "Please manualy move "
			eerror "/var/calculate/server-data/samba/win/netlogon"
			eerror "/var/calculate/server-data/samba/netlogon"
		fi
	fi

	if [ "${MAILUPDATE}" == "TRUE" ];
	then
	    ewarn
		ewarn "Please update mail service by the command:"
		ewarn "\tcl-update mail"
	fi
	if [ "${SAMBAUPDATE}" == "TRUE" ];
	then
	    ewarn
		ewarn "Please update samba service by the command:"
		ewarn "\tcl-update samba"
	fi

	ewarn
	ewarn "WARNING!!! If you have the samba service, then update it by the command:"
	ewarn "\tcl-update samba"
}
