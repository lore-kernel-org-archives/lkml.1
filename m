Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbYLARgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbYLARgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 12:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYLARgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 12:36:42 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:44005 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYLARgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 12:36:41 -0500
Date: Mon, 1 Dec 2008 18:36:39 +0100
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
       Christophe Saout <christophe@saout.de>,
       LKML <linux-kernel@vger.kernel.org>, Herbert@redhat.com,
       linux-next@vger.kernel.org, linux-crypto@vger.kernel.org,
       Xu <herbert@gondor.apana.org.au>
Subject: Re: [dm-devel] Re: next-20081125: crypto hard disk gets
	unaccessable
Message-ID: <20081201173639.GE8005@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	Milan Broz <mbroz@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	Christophe Saout <christophe@saout.de>,
	LKML <linux-kernel@vger.kernel.org>, Herbert@redhat.com,
	linux-next@vger.kernel.org, linux-crypto@vger.kernel.org,
	Xu <herbert@gondor.apana.org.au>
References: <20081128063355.GA4700@denkbrett.schottelius.org> <20081129192939.925275f0.akpm@linux-foundation.org> <49332CC6.4080606@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a+b56+3nqLzpiR9O"
Content-Disposition: inline
In-Reply-To: <49332CC6.4080606@redhat.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.28-rc4-denkbrett x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a+b56+3nqLzpiR9O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Milan Broz [Mon, Dec 01, 2008 at 01:16:06AM +0100]:
> Andrew Morton wrote:
> > (cc's added)
> >=20
> >> After about four suspend & resume operations in the midst of editing
> >> a file, the system beeped twice and issued this error:
>=20
> Did this work before?

yep

> If so, please can you provide version where
> it works?

2.6.28-rc6

> It is suspend to encrypted swap?

No, suspend to ram.

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--a+b56+3nqLzpiR9O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk0IKYACgkQuL75KpiFGIxnqACcDklSGoWardXdYmqB72ttBQJH
2oQAnRQdkQk6xKyTAA+NsdWSERJ9Zfr2
=VGKU
-----END PGP SIGNATURE-----

--a+b56+3nqLzpiR9O--
