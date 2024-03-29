# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/daq/daq-0.6.1.ebuild,v 1.1 2011/09/22 17:45:57 patrick Exp $

EAPI="2"

inherit eutils multilib

DESCRIPTION="Data Acquisition library, for packet I/O"
HOMEPAGE="http://www.snort.org/"
SRC_URI="http://www.snort.org/downloads/1098 -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6 +afpacket +dump +pcap nfq ipq static-libs"

DEPEND="pcap? ( >=net-libs/libpcap-1.0.0 )
		dump? ( >=net-libs/libpcap-1.0.0 )
		nfq? ( dev-libs/libdnet
			>=net-firewall/iptables-1.4.10
			net-libs/libnetfilter_queue )
		ipq? ( dev-libs/libdnet
			>=net-firewall/iptables-1.4.10
			net-libs/libnetfilter_queue )"

RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_enable ipv6) \
		$(use_enable pcap pcap-module) \
		$(use_enable afpacket afpacket-module) \
		$(use_enable dump dump-module) \
		$(use_enable nfq nfq-module) \
		$(use_enable ipq ipq-module) \
		$(use_enable static-libs static) \
		--disable-ipfw-module \
		--disable-bundled-modules
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog README

	# Remove unneeded .la files
	rm "${D}"usr/$(get_libdir)/daq/*.la || die
	rm "${D}"usr/$(get_libdir)/libdaq*.la || die
	rm "${D}"usr/$(get_libdir)/libsfbpf.la || die

	# If not using static-libs don't install the static libraries
	# This has been bugged upstream
	if ! use static-libs; then
		rm "${D}"usr/$(get_libdir)/libdaq_*.a || die
	fi
}

pkg_postinst() {
	einfo "The Data Acquisition library (DAQ) for packet I/O replaces direct"
	einfo "calls to PCAP functions with an abstraction layer that facilitates"
	einfo "operation on a variety of hardware and software interfaces without"
	einfo "requiring changes to application such as Snort."
	einfo
	einfo "Please see the README file for DAQ for information about specific"
	einfo "DAQ modules."
}
