Return-Path: <linux-kernel-owner+w=401wt.eu-S1030227AbXBTQ2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030227AbXBTQ2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030232AbXBTQ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:28:42 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:3124 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030230AbXBTQ2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:28:41 -0500
Message-ID: <45DB218E.1080106@imap.cc>
Date: Tue, 20 Feb 2007 17:27:58 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] kbuild: Add the code maturity levels DEPRECATED and OBSOLETE.
References: <Pine.LNX.4.64.0702181203360.5131@CPE00045a9c397f-CM001225dbafb6> <200702181935.07454.bzolnier@gmail.com>
In-Reply-To: <200702181935.07454.bzolnier@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6E7617774113403E5EA31C4A"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6E7617774113403E5EA31C4A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, 18 Feb 2007 19:35:07 +0100, Bartlomiej Zolnierkiewicz wrote:
> I think that the patch is useful and that the distinction between
> DEPRECATED and OBSOLETE options is quite clear:
>=20
> * DEPRECATED =3D=3D new better code is available, old code scheduled fo=
r removal
>=20
> * OBSOLETE =3D=3D no replacement yet but the code is broken by design
>   and unreliable, not scheduled for removal yet

Is that really the consensus on these definitions? I thought it was
more or less the opposite:

* DEPRECATED =3D=3D no (complete) replacement available yet, but it has
  been decided that this code is less than optimal and alternatives
  should be preferred

* OBSOLETE =3D=3D replacement available, no reason to use this code anymo=
re

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig6E7617774113403E5EA31C4A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF2yGOMdB4Whm86/kRApaXAJ9N8Xh1kW2I/RWw0e/uFL+y7aj8OwCeIQpy
ojATqJwdaauvXPKMavJ+ClE=
=ribX
-----END PGP SIGNATURE-----

--------------enig6E7617774113403E5EA31C4A--
