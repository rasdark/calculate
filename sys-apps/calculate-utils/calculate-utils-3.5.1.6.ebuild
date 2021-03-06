# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=(python2_7)

declare -A CALCULATE_MODULES=(
	["lib"]="3.5.1.5"
	["install"]="3.5.1.2"
	["i18n"]="3.5.1.3"
	["console-gui"]="3.5.1.1"
	["update"]="3.5.1.6"
	["builder"]="3.5.1.2"
)

inherit calculate-utils-r1

DESCRIPTION="A set of Calculate utilities for system installation, build and upgrade"
HOMEPAGE="http://www.calculate-linux.org/main/en/calculate_utilities"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64 x86"

