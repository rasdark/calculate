# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit distutils eutils

SRC_URI="ftp://ftp.calculate.ru/pub/calculate/calculate3/${PN}/${P}.tar.bz2"

DESCRIPTION="The utilities for assembling tasks of Calculate Linux"
HOMEPAGE="http://www.calculate-linux.org/main/en/calculate2"
LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=sys-apps/calculate-lib-3.0.0_beta3"

DEPEND="sys-devel/gettext
	${DEPEND}"

src_unpack() {
	unpack "${A}"
	cd "${S}"

	# fix translate
	epatch "${FILESDIR}/calculate-i18n-3.0.0_beta3-r5.patch"
}
