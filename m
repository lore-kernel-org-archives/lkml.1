Return-Path: <linux-kernel-owner+w=401wt.eu-S1763684AbXE1Wyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763684AbXE1Wyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbXE1Wyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:54:44 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:42834 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbXE1Wyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:54:43 -0400
Subject: Re: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by
	default
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200705290051.23006.rjw@sisk.pl>
References: <200705270012.59177.rjw@sisk.pl>
	 <200705282017.51210.rjw@sisk.pl>
	 <1180387582.4102.38.camel@nigel.suspend2.net>
	 <200705290051.23006.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7dk9JWN+dFSIvEhLliNm"
Date: Tue, 29 May 2007 08:54:41 +1000
Message-Id: <1180392881.4149.20.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7dk9JWN+dFSIvEhLliNm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Tue, 2007-05-29 at 00:51 +0200, Rafael J. Wysocki wrote:
> > The copy_flags routine changes another process's flags - that's why
> I
> > was suggesting this.
>=20
> Yes, it does, but I'm dropping the clearing of PF_NOFREEZE from there,
> not adding anything new. :-)

Doh! Sorry :)

Nigel

--=-7dk9JWN+dFSIvEhLliNm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGW12xN0y+n1M3mo0RAvw0AJ0aXSMf9fbzxFjOCK+KpdjXaNaEYQCfaTbp
OV5AX5VAmmBDl6g3Ijg/p08=
=gsTO
-----END PGP SIGNATURE-----

--=-7dk9JWN+dFSIvEhLliNm--

