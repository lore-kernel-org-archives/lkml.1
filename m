Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbXEaV4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbXEaV4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 17:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbXEaV4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 17:56:15 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:43089 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbXEaV4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 17:56:15 -0400
Subject: Re: [RFC][PATCH -mm 1/3] PM: Hibernation and suspend notifiers
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>
In-Reply-To: <200705312202.53945.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0705281155270.22682-100000@netrider.rowland.org>
	 <200705310744.44488.rjw@sisk.pl> <20070531142357.GK27309@elf.ucw.cz>
	 <200705312202.53945.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZGjxkAdMCOV084VoiF5p"
Date: Fri, 01 Jun 2007 07:56:17 +1000
Message-Id: <1180648577.17682.13.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZGjxkAdMCOV084VoiF5p
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-05-31 at 22:02 +0200, Rafael J. Wysocki wrote:
> Hi,
>=20
> On Thursday, 31 May 2007 16:23, Pavel Machek wrote:
> > Hi!
> >=20
> > > > > I'll post revised patches in a new thread.
> > > >=20
> > > > I haven't been giving this much attention, so forgive me if I'm abo=
ut to
> > > > ask a silly question... which notifiers would you see the avenrun
> > > > saving/restoring using?
> > >=20
> > > I'm not sure what you mean.  Could you please clarify?
> >=20
> > Remember that patch about saving/restoring "load average"? I guess
> > Nigel asks where to hook it.
>=20
> Ah, okay, thanks.
>=20
> Hmm, that would be PM_PRE_HIBERNATION, I think.

Yeah. Okee doke.

Thanks!

Nigel

--=-ZGjxkAdMCOV084VoiF5p
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGX0SBN0y+n1M3mo0RAmqdAKC+fQ6fS4cSx690mdlCvU7u1NzANwCeNGvb
/rIjw4g91Z08laHa0PthHv4=
=Ccx1
-----END PGP SIGNATURE-----

--=-ZGjxkAdMCOV084VoiF5p--

