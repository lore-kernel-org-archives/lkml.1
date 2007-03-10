Return-Path: <linux-kernel-owner+w=401wt.eu-S933492AbXCJQxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492AbXCJQxe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 11:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933490AbXCJQxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 11:53:34 -0500
Received: from mx.laposte.net ([81.255.54.11]:12552 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933492AbXCJQxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 11:53:32 -0500
Subject: Re: [PATCH][RSDL-mm 0/6]  Rotating Staircase DeadLine scheduler 
	for -mm
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200703110103.21224.kernel@kolivas.org>
References: <1173527368.3380.1.camel@rousalka.dyndns.org>
	 <200703110103.21224.kernel@kolivas.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-q3B2bAd5c9mLuKJFIpX4"
Organization: Adresse perso
Date: Sat, 10 Mar 2007 17:53:28 +0100
Message-Id: <1173545608.4143.10.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 (2.9.92-1.fc7.1) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-q3B2bAd5c9mLuKJFIpX4
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le dimanche 11 mars 2007 =C3=A0 01:03 +1100, Con Kolivas a =C3=A9crit :
> On Saturday 10 March 2007 22:49, Nicolas Mailhot wrote:
> > Oops
> >
> > =E2=87=92 http://bugzilla.kernel.org/show_bug.cgi?id=3D8166
>=20
> Thanks very much. I can't get your config to boot on qemu, but could you=20
> please try this debugging patch? It's not a patch you can really run the=20
> machine with but might find where the problem occurs. Specifically I'm=20
> looking for the warning MISSING STATIC BIT in your case.=20
>=20
> http://ck.kolivas.org/patches/crap/sched-rsdl-0.28-stuff.patch

I attached a screenshot of the patched kernel boot

--=20
Nicolas Mailhot

--=-q3B2bAd5c9mLuKJFIpX4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iEYEABECAAYFAkXy4ogACgkQI2bVKDsp8g2OaACfSY+F7jv4v17Wx/rLO1liT8Xr
1/cAoPl/DvdiNnDcENrVfqx33Z2cFD8p
=z+vN
-----END PGP SIGNATURE-----

--=-q3B2bAd5c9mLuKJFIpX4--
