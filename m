Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZG2MEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZG2MEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbZG2MEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:04:39 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:36633 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbZG2MEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:04:38 -0400
Subject: Re: [Bug #13845] inotify regression, missing events
From: Scott James Remnant <scott@ubuntu.com>
To: Eric Paris <eparis@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <1248812102.15671.0.camel@localhost>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
	 <3zAHs5O6maO.A.ATB.-GObKB@chimera> <1248683738.22308.0.camel@quest>
	 <200907280052.44653.rjw@sisk.pl>  <1248812102.15671.0.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NgBWNOL97O7ujlzklrCb"
Date: Wed, 29 Jul 2009 13:04:20 +0100
Message-Id: <1248869060.23840.10.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NgBWNOL97O7ujlzklrCb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-28 at 16:15 -0400, Eric Paris wrote:

> On Tue, 2009-07-28 at 00:52 +0200, Rafael J. Wysocki wrote:
> > On Monday 27 July 2009, Scott James Remnant wrote:
> > > On Sun, 2009-07-26 at 22:28 +0200, Rafael J. Wysocki wrote:
> > >=20
> > > > This message has been generated automatically as a part of a report
> > > > of recent regressions.
> > > >=20
> > > > The following bug entry is on the current list of known regressions
> > > > from 2.6.30.  Please verify if it still should be listed and let me=
 know
> > > > (either way).
> > > >=20
> > > >=20
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13845
> > > > Subject		: inotify regression, missing events
> > > > Submitter	: Scott James Remnant <scott@ubuntu.com>
> > > > Date		: 2009-07-11 16:02 (16 days old)
> > > > References	: http://marc.info/?l=3Dlinux-kernel&m=3D124732816314881=
&w=3D4
> > > > Handled-By	: Eric Paris <eparis@redhat.com>
> > > >=20
> > > This patch hasn't found its way into Linus' tree yet, so it's definit=
ely
> > > still an issue and should be listed.
> >=20
> > Thanks for the update
>=20
> Looks like it was pulled into Linus's tree last night if you would like
> to test and verify.
>=20
Tested and verified, good work!

Thanks,

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-NgBWNOL97O7ujlzklrCb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpwOsQACgkQSnQiFMl4yK7sxgCdH0q6Usn3wYpConvBUUsv5DfV
ggYAn3XOQspHdY2ebOdkbDq75q1c60/A
=xlzn
-----END PGP SIGNATURE-----

--=-NgBWNOL97O7ujlzklrCb--

