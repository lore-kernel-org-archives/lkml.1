Return-Path: <linux-kernel-owner+w=401wt.eu-S1761925AbZDAQEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbZDAQEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762485AbZDAQDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:03:37 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:38442 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762338AbZDAQDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:03:36 -0400
Date: Wed, 1 Apr 2009 18:03:33 +0200
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Invalid module format (was: Re: linux-next: Tree for April 1)
Message-ID: <20090401160333.GA5249@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	Gabriel C <nix.or.die@googlemail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20090401164450.f8192631.sfr@canb.auug.org.au> <20090401150928.GA5886@denkbrett.schottelius.org> <1820d69d0904010852qc07ccc7qc9cec18bcc2837bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <1820d69d0904010852qc07ccc7qc9cec18bcc2837bd@mail.gmail.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-wl-36123-g39fb448 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Gabriel C [Wed, Apr 01, 2009 at 05:52:59PM +0200]:
> 2009/4/1 Nico -telmich- Schottelius <nico-linux-next@schottelius.org>:
> > Stephen Rothwell [Wed, Apr 01, 2009 at 04:44:50PM +1100]:
> >> Hi all,
> >>
> >> Changes since 20090331:
> >
> > Same problem since 20090324.
>=20
> AFAIK it is since 20090218...
>=20
> >
> > arch=3Damd64, config attached, all modules have that problem.
>=20
> Disabling CONFIG_MODVERSIONS should workaround this problem.

Ahh, thanks! So I'll trac wireless-testing and iwlwifi for now, they
do have enough bugs for me :-)

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknTkFUACgkQuL75KpiFGIwvrgCgxzY/iMx6OnyiQqIiLCqvnZSR
HWoAn0GqQtsk8n0QWznqSzloybOuOu1y
=8OmZ
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
