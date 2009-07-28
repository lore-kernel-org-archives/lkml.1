Return-Path: <linux-kernel-owner+w=401wt.eu-S1751581AbZG1AKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbZG1AKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 20:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbZG1AKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 20:10:08 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:36615 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZG1AKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 20:10:07 -0400
Date: Mon, 27 Jul 2009 21:09:46 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #13643] Touchpad lost synchronization after resume from
	suspend to RAM
Message-ID: <20090728000945.GA13815@vespa.holoscopio.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.JcF.gIObKB@chimera> <20090726233331.GA4712@vespa.holoscopio.com> <200907280015.56826.rjw@sisk.pl> <20090727225946.048A3526EC9@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20090727225946.048A3526EC9@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 27, 2009 at 03:25:51PM -0700, Dmitry Torokhov wrote:
> On Tue, Jul 28, 2009 at 12:15:54AM +0200, Rafael J. Wysocki wrote:
> > On Monday 27 July 2009, Thadeu Lima de Souza Cascardo wrote:
> > > On Sun, Jul 26, 2009 at 10:23:34PM +0200, Rafael J. Wysocki wrote:
> > > > This message has been generated automatically as a part of a report
> > > > of recent regressions.
> > > >=20
> > > > The following bug entry is on the current list of known regressions
> > > > from 2.6.30.  Please verify if it still should be listed and let me=
 know
> > > > (either way).
> > > >=20
> > > >=20
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13643
> > > > Subject		: Touchpad lost synchronization after resume from suspend =
to RAM
> > > > Submitter	: Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>
> > > > Date		: 2009-06-28 10:42 (29 days old)
> > > > References	: http://lkml.org/lkml/2009/6/23/365
> > > > 		  2.6.30-rc1: touchpad disabled
> > > > 		  http://lkml.org/lkml/2009/6/25/256
> > > > Handled-By	: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > > > Patch		: http://patchwork.kernel.org/patch/34075/
> > > >=20
> > > >=20
> > >=20
> > > I guess my patch did fix it and we had other confirmations as well,
> > > didn't we?
> >=20
> > Yes, we did.  It's waiting in the Dmirty's tree for Linus to take it AF=
AICS.
> >=20
>=20
> I believe it is in -rc4 actually.
>=20
> --=20
> Dmitry

It entered in v2.6.31-rc3. Thanks, Dimitry.

cascardo@vespa:~/linux$ git log1 --author=3Dcascardo v2.6.31-rc2..v2.6.31-r=
c3
ddaa43433dd77535e4e132787f199f58ce224f44 Input: mark serio and i8042 as sus=
pende
cascardo@vespa:~/linux$

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpuQckACgkQyTpryRcqtS2y4gCdG1nAnxC+aO3bGcL7Op80wSNO
QaIAoJKThprOS7HkYsL7Nv0v1x18pVD9
=7CEo
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
