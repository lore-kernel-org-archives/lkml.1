Return-Path: <linux-kernel-owner+w=401wt.eu-S1765331AbXEWN4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765331AbXEWN4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbXEWNzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:55:54 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:49682 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285AbXEWNzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:55:54 -0400
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
In-Reply-To: <943F0161-121D-4697-AE69-78BD605A8033@kernel.crashing.org>
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
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-H3pVsnDIXxIyWUvzECuo"
Date: Wed, 23 May 2007 15:57:25 +0200
Message-Id: <1179928646.14317.6.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-H3pVsnDIXxIyWUvzECuo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-05-23 at 07:37 -0500, Kumar Gala wrote:

> Was my patch ok, if so I'll push it up through my git tree to paul?

Yeah, looks fine to me, or will the ARCH=3Dppc folks then scream and want
that added to the Kconfig there as well?

johannes

--=-H3pVsnDIXxIyWUvzECuo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGVEhF/ETPhpq3jKURAsUfAKCfexsuYQcwRCUISIPwLRtmhxb2PgCgm6FF
k7INBoG36baO8qii66A0jzc=
=ABIF
-----END PGP SIGNATURE-----

--=-H3pVsnDIXxIyWUvzECuo--

