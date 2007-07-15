Return-Path: <linux-kernel-owner+w=401wt.eu-S1759837AbXGOXNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837AbXGOXNL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbXGOXM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:12:58 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:53540 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbXGOXM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:12:57 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Patches for REALLY TINY 386 kernels
Date: Mon, 16 Jul 2007 09:12:55 +1000
User-Agent: KMail/1.9.6
Cc: Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org,
       torvalds@transmeta.com
References: <469A8AED.7070207@nerdgrounds.com> <200707160742.25232.nigel@nigel.suspend2.net> <20070715234526.13813f8f@the-village.bc.nu>
In-Reply-To: <20070715234526.13813f8f@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1336762.3sP1gjSYDE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707160912.55701.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1336762.3sP1gjSYDE
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 16 July 2007 08:45:26 Alan Cox wrote:
> > > These patches were written against the vanilla 2.6.21.1 kernel. They=
=20
> > > will have no effect UNLESS you make menuconfig and explicitly enable=
=20
> > > them there.
> >=20
> > Would you please make mrproper before preparing the patch? It's harder =
to=20
read=20
> > with all the "Only in..." lines.
>=20
> A lot simpler is to feed the patch through "grep -v"

Yeah. I was going for the general principle :)

Nigel
=2D-=20
Nigel Cunningham
Christian Reformed Church of Cobden
103 Curdie Street, Cobden 3266, Victoria, Australia
Ph. +61 3 5595 1185 / +61 417 100 574
Communal Worship: 11 am Sunday.

--nextPart1336762.3sP1gjSYDE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGmqn3N0y+n1M3mo0RAmkNAKDsTawRh2S+CEcxudxRM1zQGl7XhACgv7qk
bUIYpZefalIzq88heLZnRFo=
=dK3g
-----END PGP SIGNATURE-----

--nextPart1336762.3sP1gjSYDE--
