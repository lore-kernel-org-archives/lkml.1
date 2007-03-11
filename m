Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbXCKJLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbXCKJLJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 05:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbXCKJLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 05:11:09 -0400
Received: from mx.laposte.net ([81.255.54.11]:41862 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbXCKJLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 05:11:08 -0400
Subject: [BIG] Re: sched rsdl fix for 0.28
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
In-Reply-To: <200703111107.00704.kernel@kolivas.org>
References: <200703111107.00704.kernel@kolivas.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HJW6zLqXcgzMGdvC3bhZ"
Organization: Adresse perso
Date: Sun, 11 Mar 2007 10:10:23 +0100
Message-Id: <1173604223.3550.2.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 (2.9.92-1.fc7.1) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HJW6zLqXcgzMGdvC3bhZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le dimanche 11 mars 2007 =C3=A0 11:07 +1100, Con Kolivas a =C3=A9crit :
> sched rsdl fix

Doesn't change a thing. Always breaks at the same place (though
depending on hardware timings? the trace is not always the same). Pretty
sure nothing happens before this failure

--=20
Nicolas Mailhot

--=-HJW6zLqXcgzMGdvC3bhZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iEYEABECAAYFAkXzx3oACgkQI2bVKDsp8g1YiQCeN8PjG/QkCPYVFcAqsjOBJ++f
QQQAoML4MOumgskbehTk18sdYw13Nl6W
=++F2
-----END PGP SIGNATURE-----

--=-HJW6zLqXcgzMGdvC3bhZ--
