# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/syslinux/syslinux-3.75.ebuild,v 1.1 2009/04/29 15:51:18 jer Exp $

inherit eutils

[[ ${PV} =~ ([0-9]+)\.([0-9]+)\.([0-9]+) ]]

SYSLINUX_PV=${BASH_REMATCH[1]}.${BASH_REMATCH[2]}
SYSLINUX_PN=syslinux
SYSLINUX_P=${SYSLINUX_PN}-${SYSLINUX_PV}
SYSLINUX_PF=${SYSLINUX_P}

DESCRIPTION="SysLinux with calcboot module calcmenu.c32"
HOMEPAGE="http://www.calculate-linux.ru/calcboot"
SRC_URI="mirror://kernel/linux/utils/boot/syslinux/${SYSLINUX_P}.tar.bz2
         ftp://ftp.calculate.ru/pub/calculate/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="!sys-boot/syslinux"
DEPEND="${RDEPEND}"

# This ebuild is a departure from the old way of rebuilding everything in syslinux
# This departure is necessary since hpa doesn't support the rebuilding of anything other
# than the installers.

# removed all the unpack/patching stuff since we aren't rebuilding the core stuff anymore

S=${WORKDIR}/${SYSLINUX_P}

src_unpack() {
	unpack ${SYSLINUX_P}.tar.bz2
	cd "${S}"
	cd com32/menu
	unpack ${P}.tar.bz2
	cd ../..
	epatch "${FILESDIR}"/${SYSLINUX_PN}-3.72-nopie.patch
	# Don't prestrip, makes portage angry
	epatch "${FILESDIR}"/${SYSLINUX_PN}-3.72-nostrip.patch

	rm -f gethostip #bug 137081
}

src_compile() {
	emake installer || die
	cd com32
	emake || die
}

src_install() {
	emake INSTALLROOT="${D}" MANDIR=/usr/share/man local-install || die
	PF=${SYSLINUX_PF}
	dodoc README NEWS TODO doc/*
	insinto /usr/share/syslinux
	cd com32/menu
	doins calcmenu.c32
}
