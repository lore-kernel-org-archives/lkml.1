Return-Path: <linux-kernel-owner+w=401wt.eu-S1764599AbXEWOYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764599AbXEWOYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 10:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbXEWOYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 10:24:30 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:58355 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbXEWOYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 10:24:30 -0400
Subject: Re: Kconfig warnings on latest GIT
From: Johannes Berg <johannes@sipsolutions.net>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Simon Horman <horms@verge.net.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       ppc-dev dev ML <linuxppc-dev@ozlabs.org>
In-Reply-To: <Pine.LNX.4.64.0705230913420.535@localhost.localdomain>
References: <200705080004.14570.ismail@pardus.org.tr>
	 <20070508143127.38fafa3c.kim.phillips@freescale.com>
	 <4640D988.1040504@freescale.com> <20070510051042.GA16812@verge.net.au>
	 <1178811570.3806.18.camel@johannes.berg>
	 <20070511012216.GB10715@verge.net.au>
	 <1178883937.8896.11.camel@johannes.berg>
	 <20070514013230.GJ3588@verge.net.au>
	 <1179147311.2647.47.camel@johannes.berg>
	 <Pine.LNX.4.64.0705140923470.24559@gate.crashing.org>
	 <1179159951.2647.49.camel@johannes.berg>
	 <943F0161-121D-4697-AE69-78BD605A8033@kernel.crashing.org>
	 <1179928646.14317.6.camel@johannes.berg>
	 <Pine.LNX.4.64.0705230913420.535@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S7zF+zkaPY6pUIFCHChx"
Date: Wed, 23 May 2007 16:26:05 +0200
Message-Id: <1179930365.14317.14.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-S7zF+zkaPY6pUIFCHChx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-05-23 at 09:14 -0500, Kumar Gala wrote:
> On Wed, 23 May 2007, Johannes Berg wrote:
>=20
> > On Wed, 2007-05-23 at 07:37 -0500, Kumar Gala wrote:
> >
> > > Was my patch ok, if so I'll push it up through my git tree to paul?
> >
> > Yeah, looks fine to me, or will the ARCH=3Dppc folks then scream and wa=
nt
> > that added to the Kconfig there as well?
>=20
> I can't imagine they will since pmac is only supported in ARCH=3Dpowerpc.

Oh right, that was the point of not mentioning
SYS_SUPPORTS_APM_EMULATION any more in the drivers/macintosh/Kconfig

johannes

--=-S7zF+zkaPY6pUIFCHChx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGVE79/ETPhpq3jKURAsoLAKCNDt2BvRicYLq+ZjM9YrU4hReDggCfcwwS
qDd9/PWsdM2kp9MLcElVhaA=
=k3Py
-----END PGP SIGNATURE-----

--=-S7zF+zkaPY6pUIFCHChx--

