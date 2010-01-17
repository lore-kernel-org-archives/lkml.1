Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794Ab0AQXEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0AQXEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 18:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351Ab0AQXEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 18:04:53 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:50633 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab0AQXEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 18:04:52 -0500
Date: Sun, 17 Jan 2010 21:02:18 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: trivial@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] trivial: fix typo s/programme/program/ in mtrr
 documentation
Message-ID: <20100117230217.GA1520@holoscopio.com>
References: <1263763552-9656-1-git-send-email-cascardo@holoscopio.com>
 <20100117135358.7db2e7f5.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20100117135358.7db2e7f5.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 17, 2010 at 01:53:58PM -0800, Randy Dunlap wrote:
> On Sun, 17 Jan 2010 19:25:51 -0200 Thadeu Lima de Souza Cascardo wrote:
>=20
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > ---
> >  Documentation/x86/mtrr.txt |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/Documentation/x86/mtrr.txt b/Documentation/x86/mtrr.txt
> > index cc071dc..3ffcbea 100644
> > --- a/Documentation/x86/mtrr.txt
> > +++ b/Documentation/x86/mtrr.txt
> > @@ -195,11 +195,11 @@ int main ()
> >      exit (3);
> >  }   /*  End Function main  */
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > -Creating MTRRs from a C programme using ioctl()'s:
> > +Creating MTRRs from a C program using ioctl()'s:
> > =20
> >  /*  mtrr-add.c
> > =20
> > -    Source file for mtrr-add (example programme to add an MTRRs using =
ioctl())
> > +    Source file for mtrr-add (example program to add MTRRs using ioctl=
())
> > =20
> >      Copyright (C) 1997-1998  Richard Gooch
> > =20
> > @@ -223,7 +223,7 @@ Creating MTRRs from a C programme using ioctl()'s:
> >  */
> > =20
> >  /*
> > -    This programme will use an ioctl() on /proc/mtrr to add an entry. =
The first
> > +    This program will use an ioctl() on /proc/mtrr to add an entry. Th=
e first
> >      available mtrr is used. This is an alternative to writing /proc/mt=
rr.
> > =20
> > =20
> > --=20
>=20
> We accept UK/British English spellings as is.
>=20

Sorry. I should've checked this was a good spell, which I was not familiar =
with.

Regards,
Cascardo.

> ---
> ~Randy

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktTlvkACgkQyTpryRcqtS1ByACfQxdbyBT3dx6vdobQ/BraUZag
dbsAnAx2LUvZ6/KkBYhnDBIevP4O1Zfc
=vd7o
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
