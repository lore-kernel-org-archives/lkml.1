Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab0BQWBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:01:46 -0500
Received: from nn7.de ([85.214.94.156]:35348 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab0BQWBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:01:45 -0500
Subject: 2.6.33-rc8-git: nouveaufb hangs on boot on MacBookPro5,3
From: Soeren Sonnenburg <sonne@debian.org>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VXAsPOeLfYVA0dqFVLqN"
Date: Wed, 17 Feb 2010 23:01:44 +0100
Message-ID: <1266444104.6276.49.camel@no>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VXAsPOeLfYVA0dqFVLqN
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Dear all,

nouveaufb hangs on MacBookPro5,3 with PFIFO_INTR 0x04000000 - Ch1 when
booting in efi mode via elilo.

I am attaching a (dirty) screenshot, maybe someone can clear this up

http://sonnenburgs.de/media/bugs/nouveau_hang_2.6.33-rc8.jpg

If there is anything else you want me to try, please say so.

Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-VXAsPOeLfYVA0dqFVLqN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJLfGdHAAoJEH82z1Wqh6p3agkP/iJCTjjPVLnhc9t+prNsz34/
Z+77jDYSQ7bRSzoyPtX/vaN+Bo73LSR3EU3EdXatAH+jWEbTvQIbHFymgXFLfMeQ
rjuQ6t7XzeZZBhPXWVXxebdKutBI1hkMjgiSApSoZ4IYNKHHesDrBz6EB49G2lo2
uD7K5hcdlZ5xiH0B/J8USeVGpeKjnDkd1JPEsbbCGtYWLATsTaij4EOZTzaLufEf
fwl0/rYy55a19dyPLHcStqQZeyJbpRDta1tbH/ZrWOIo7HjstUyJx3bfYaQ5p/3P
KMqjFL2mn210+V2UPdI6a/NjOIPZjtroR8mt3Ml7mHK+h7jHH+JDtmmxbvfhDrHL
xrsMMj84cdOYHgAnWk4/fNUuSqfk6QIdWfK3/+2d0jE3uDu5wXQsRfv8X+yzjc2n
oflW8TDFYXopKxI2OXJ+FFRwyTQL+5XbEA3SRnmqammsQ58L/OAU6eBAOllOHhCg
vjvxoaKuFphVMFQdq/hwAccA3bxegLSwyK2PonzCd50iuMc4eAVJwyRH4+pQ4OQh
FMsxajIstsw8ddQ/TZBl1qtWu8/rYZrOCedEw6AUR8eZZcZV+vuzFNOhjBzLYUjj
8nV7FaoHCTDLPwYQr6bemx/ng4vlptEqMp6uFi1IN2EV6/89jSXms6dHKgW4M9+G
ZONUadLR9a26aNj3Z/i5
=4EMF
-----END PGP SIGNATURE-----

--=-VXAsPOeLfYVA0dqFVLqN--
