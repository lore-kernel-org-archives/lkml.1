Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbYDYNeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbYDYNeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 09:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832AbYDYNeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 09:34:01 -0400
Received: from ozlabs.org ([203.10.76.45]:59888 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749AbYDYNeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 09:34:00 -0400
Subject: Re: linux-next: Tree for April 24
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
In-Reply-To: <20080425172039.326f4bfd.sfr@canb.auug.org.au>
References: <20080424173626.bcd088e7.sfr@canb.auug.org.au>
	 <Pine.LNX.4.64.0804240942300.10239@vixen.sonytel.be>
	 <20080424193023.862cacd7.sfr@canb.auug.org.au>
	 <Pine.LNX.4.64.0804241311330.7107@anakin>
	 <20080425172039.326f4bfd.sfr@canb.auug.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UfI5PnHUrriMlyuY8Fge"
Date: Fri, 25 Apr 2008 23:32:55 +1000
Message-Id: <1209130375.30293.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UfI5PnHUrriMlyuY8Fge
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-04-25 at 17:20 +1000, Stephen Rothwell wrote:
> Hi Geert,
>=20
> On Thu, 24 Apr 2008 13:12:16 +0200 (CEST) Geert Uytterhoeven <geert@linux=
-m68k.org> wrote:
> >
> > BTW, the results of today all seem to are unaccessible?
> >=20
> > E.g. http://kisskb.ellerman.id.au/kisskb/buildresult/25192/
> >=20
> >     Forbidden
> >=20
> >     You don't have permission to access /kisskb/buildresult/25195/ on t=
his
> >     server.
>=20
> These results pages are mirrored from an inaccessible server.  Sometimes
> they don't get all the pages mirrored in one go (I assume).  Please try
> again later.

We take a snapshot with wget, that /should/ be consistent, ie. no
dangling links. But then that gets rsync'ed, and it's possible if you're
browsing while the rsync is going you'll get a link to nowhere.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-UfI5PnHUrriMlyuY8Fge
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIEd2HdSjSd0sB4dIRAsETAJ9esF6CIKys3BC0W08gWhd0Z+XanACgxssf
tsScLKJoCovEF8Q6BKHObVU=
=JQuI
-----END PGP SIGNATURE-----

--=-UfI5PnHUrriMlyuY8Fge--

