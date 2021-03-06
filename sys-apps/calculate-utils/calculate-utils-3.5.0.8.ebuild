# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=(python2_7)

declare -A CALCULATE_MODULES=(
	["lib"]="3.5.0.5"
	["install"]="3.5.0.1"
	["core"]="3.5.0.1"
	["client"]="3.5.0.1"
	["desktop"]="3.5.0.2"
	["builder"]="3.5.0.2"
	["ldap"]="3.5.0.1"
)

inherit calculate-utils-r1

DESCRIPTION="A set of Calculate utilities for system installation, build and upgrade"
HOMEPAGE="http://www.calculate-linux.org/main/en/calculate_utilities"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64 x86"

