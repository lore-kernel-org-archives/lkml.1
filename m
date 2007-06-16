Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbXFPNIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbXFPNIw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 09:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbXFPNIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 09:08:44 -0400
Received: from mx.laposte.net ([81.255.54.16]:34959 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbXFPNIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 09:08:43 -0400
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1181998132.4388.125.camel@rousalka.dyndns.org>
References: <64689.192.54.193.51.1181901773.squirrel@rousalka.dyndns.org>
	 <49716.192.54.193.51.1181907924.squirrel@rousalka.dyndns.org>
	 <1181998132.4388.125.camel@rousalka.dyndns.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fLelBw+FDqb5c/Uvivwt"
Organization: Adresse perso
Date: Sat, 16 Jun 2007 15:08:35 +0200
Message-Id: <1181999315.21822.4.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.3 (2.11.3-4.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fLelBw+FDqb5c/Uvivwt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I read it: the flash contains everything from the bootloader to the
> kernel and file system. The bootloader contains the public key and
> checks if the kernel/fs
> are ok. That includes calculating hashes and checking signatures.
> No encryption/decryption there at all.
>=20
> Right?
>=20
> Then how hard would it be to reprogram the flash, to get rid of all
> this crap? Or to just put your public key there.

Legally totally impossible under DMCA, EUCD and friends

That why the GPLv3 has the distributor of the software both give
installation info (a key authorized on the device, not necessarily a key
authorized on all devices or even the same key as the manufacturer), and
declare he gaves up any DMCA-like right to legally forbid installation
by the user.

--=20
Nicolas Mailhot

--=-fLelBw+FDqb5c/Uvivwt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iEYEABECAAYFAkZz4M4ACgkQI2bVKDsp8g2+BwCfUgfcOuYbk7T0uhLxL/1zSPfS
UJQAoPx4K6NCzibTAvIKUiAmFCFqGhSH
=HbIL
-----END PGP SIGNATURE-----

--=-fLelBw+FDqb5c/Uvivwt--
