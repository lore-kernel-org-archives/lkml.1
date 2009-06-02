Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbZFBGdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbZFBGdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 02:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759221AbZFBGdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 02:33:39 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55652 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759140AbZFBGdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 02:33:39 -0400
Subject: Re: [PATCH] update kernel's scripts/bloat-o-meter from busybox
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Joe Perches <joe@perches.com>
Cc: Rob Landley <rob@landley.net>, Matt Mackall <mpm@selenic.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>,
       Denis Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1243923058.3402.66.camel@Joe-Laptop.home>
References: <200906011526.01108.rgetz@blackfin.uclinux.org>
	 <1243885732.22069.112.camel@calx>  <200906020059.18603.rob@landley.net>
	 <1243923058.3402.66.camel@Joe-Laptop.home>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rg8KkwKA8u9k22NpoBWO"
Date: Tue, 02 Jun 2009 16:33:39 +1000
Message-Id: <1243924419.6119.3.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rg8KkwKA8u9k22NpoBWO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-01 at 23:10 -0700, Joe Perches wrote:
> On Tue, 2009-06-02 at 00:59 -0500, Rob Landley wrote:
> > P.S.  I'd attach the 5 patch+descriptions, but I just spent fifteen min=
utes=20
> > fighting with git to try to convince "git log -p" that when I list a sp=
ecific=20
> > commit on the command line I want it to spit out the description and pa=
tch for=20
> > JUST THAT ONE COMMIT and not log the history back to Grace Hopper's gra=
duation=20
> > ceremony
>=20
> git log -p -1 commit

Or more simply:

git show <commit>

cheers

--=-rg8KkwKA8u9k22NpoBWO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkokx8MACgkQdSjSd0sB4dJVHACgvdtQSIsOI718acUC4ROEnp/W
V3gAmwTLeZkhW2iBqzL1/s8LAxI+od8I
=dmXI
-----END PGP SIGNATURE-----

--=-rg8KkwKA8u9k22NpoBWO--

