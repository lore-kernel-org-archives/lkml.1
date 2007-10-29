Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbXJ2Qmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbXJ2Qmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbXJ2Qml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:42:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:48660 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754505AbXJ2Qml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:42:41 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/X0asoqvbX/fPbDdLIjilrVpCUHPq+fx/aciOeUa
	C8nHdJAdp2GX2K
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: cpu governor ondemand issue
Date: Mon, 29 Oct 2007 17:42:35 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cpufreq@www.linux.org.uk
References: <200710211316.14955.toralf.foerster@gmx.de> <20071029000243.9101d363.akpm@linux-foundation.org> <20071029072129.653fe170@laptopd505.fenrus.org>
In-Reply-To: <20071029072129.653fe170@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1944123.y5LQddcG0I";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710291742.37654.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1944123.y5LQddcG0I
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag, 29. Oktober 2007 schrieb Arjan van de Ven:
> On Mon, 29 Oct 2007 00:02:43 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>=20
> >=20
> > And 2.6.23 was OK?
> >=20
> > Is this problem still present in Linus's current tree?
>=20
> and did you enable the "ignore nice levels" switch in sysfs ondemand
> directory?
>=20

Oh no,
if you mean /sys/devices/system/cpu/cpu0/cpufreq/ondemand/ignore_nice_load
I didn't changed anything, instead I just used the same .config file, reboo=
ted
into the new kernel and ran the test again.

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart1944123.y5LQddcG0I
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJg17hyrlCH22naMRAo7jAKC5THouicQONQfSsYgO2yfzGDSxzgCcCmGC
2Gci6xEnDUNqd7a5GYHWA/w=
=xJuY
-----END PGP SIGNATURE-----

--nextPart1944123.y5LQddcG0I--
