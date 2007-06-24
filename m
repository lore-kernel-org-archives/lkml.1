Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbXFXXTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbXFXXTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 19:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXFXXS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 19:18:57 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:39204 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbXFXXS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 19:18:56 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Failure to properly reinit i8042 post suspend-to-ram
Date: Mon, 25 Jun 2007 09:18:52 +1000
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, dmitry.torokhov@gmail.com
References: <200706221607.33274.nigel@nigel.suspend2.net> <200706242303.21065.rjw@sisk.pl>
In-Reply-To: <200706242303.21065.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1555325.xrpAWpFU3E";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706250918.52959.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1555325.xrpAWpFU3E
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Monday 25 June 2007 07:03:20 Rafael J. Wysocki wrote:
> Hi,
>=20
> On Friday, 22 June 2007 08:07, Nigel Cunningham wrote:
> > Hi.
> >=20
> > I have recently begun to try and use suspend to ram more, and have an=20
> > intermittent problem. Actually, it's a couple of (possibly related) pro=
blems,=20
> > but I'll start with the one that's easiest.
> >=20
> > Sometimes, when I resume, the keyboard stops responding. I then need to=
 hold=20
> > down the power button for 4 seconds. At the next boot, things are still=
 not=20
> > right. The i8042 controller seems to be confused about it's mode, becau=
se I=20
> > get the following differences in dmesg to a 'normal' boot:
>=20
> Well, I'm afraid no one has any idea.
>=20
> I think you can file a bug report with the kernel bugzilla.

Yeah. I think I'll do some more debugging first, though - seek to find out =
exactly what is failing.

Regards,

Nigel

=2D-=20
Nigel, Michelle and Alisdair Cunningham
5 Mitchell Street
Cobden 3266
Victoria, Australia

--nextPart1555325.xrpAWpFU3E
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGfvvcN0y+n1M3mo0RAnfdAJ97Hjau7F/dAfVVaVt7Jd4YuhWeogCfVxxs
2MlXjfPy7iEsSLlKUgL67zo=
=+bY4
-----END PGP SIGNATURE-----

--nextPart1555325.xrpAWpFU3E--
