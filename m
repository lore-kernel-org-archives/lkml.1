Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbYCBUKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbYCBUKI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 15:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbYCBUJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 15:09:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:35676 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755537AbYCBUJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 15:09:56 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/jIJF0GSTjMAvN9FpFGiJwmwVLRboyZ/q+16bBzp
	g5shasFo8OaL4f
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Re: why is CONFIG_PCI unset ? [was: build #350 issue for v2.6.25-rc1 in drivers/i2c/busses/i2c-i801.c]
Date: Sun, 2 Mar 2008 21:09:53 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Message-Id: <200803022109.53851.toralf.foerster@gmx.de>
Content-Type: multipart/signed;
  boundary="nextPart1814651.eKZzvPAmEU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1814651.eKZzvPAmEU
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,=20

At Sunday 02 March 2008 Adrian Bunk wrote :

> Why are you doing the "<tweak config file> && make oldconfig" steps at al=
l?
>=20
> Shouldn't KCONFIG_ALLCONFIG do what you want?
>=20

I grep out some stuff from the randomly generated config file.
=46urthermore I prefer to have to whole stuff together in single file.

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart1814651.eKZzvPAmEU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHywmRhyrlCH22naMRApNxAJwN0L4/LauoDQhhLHDuAJSnCzf2UwCgrh01
hEy0qtCysaFt/NZBUB6fi7E=
=YFMV
-----END PGP SIGNATURE-----

--nextPart1814651.eKZzvPAmEU--
