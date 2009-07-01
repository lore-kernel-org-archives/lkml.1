Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbZGAGMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbZGAGMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 02:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbZGAGLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 02:11:55 -0400
Received: from manchmal.in-ulm.de ([217.10.9.201]:55438 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZGAGLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 02:11:55 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2009 02:11:55 EDT
Date: Wed, 1 Jul 2009 08:04:34 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch 00/30] 2.6.27-stable review
Message-ID: <1246427880@msgid.manchmal.in-ulm.de>
References: <20090701002817.GA6156@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20090701002817.GA6156@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Greg KH wrote...

> This is the start of the stable review cycle for the 2.6.27.26 release.

Please consider

| commit 1f8ae0a21d83f43006d7f6d2862e921dbf2eeddd
| Author: Tomasz Lemiech <szpajder@staszic.waw.pl>
| Date:   Fri Mar 13 15:43:38 2009 -0700
|=20
|     tulip: Fix for MTU problems with 802.1q tagged frames

for inclusion which was added in 2.6.30 - although probably I am the
last one in the world who uses VLANs on tulip.  That patch applied on
2.6.27.25 and worked for me.  If I should do another test on top of
2.6.27.26-rc1, drop me a line.

    Christoph

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEARECAAYFAkpK/HIACgkQBq/69tVAGy2VFQCYqjOxCHO+pEyrVclIA9PzFr2b
fQCfTVnmz5ZYg8Ggqd7Kh6GOljwOc9I=
=nT+9
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
