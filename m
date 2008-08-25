Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbYHYUyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbYHYUyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbYHYUyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:54:41 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:49977 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753428AbYHYUyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:54:40 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Sally-Anne Edwards <sallyanne.edwards@googlemail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48B31522.2050101@goop.org>
References: <39fd98ca0808240801x7edbe0e6gf242f08de88cd92c@mail.gmail.com>
	 <39fd98ca0808240804p454faff9u289abfc074dbea3@mail.gmail.com>
	 <48B3099E.3060407@goop.org>
	 <1219693601.27921.172.camel@localhost.localdomain>
	 <1219695753.27921.175.camel@localhost.localdomain>
	 <48B31522.2050101@goop.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-On85wWG3bDF4AH4FyklQ"
Date: Mon, 25 Aug 2008 21:54:32 +0100
Message-Id: <1219697672.27921.178.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: Fwd: domU lenny not working: BUG: unable to handle
	kernel	paging request at e7437cc0
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-On85wWG3bDF4AH4FyklQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-25 at 13:25 -0700, Jeremy Fitzhardinge wrote:
> Ian Campbell wrote:
> > On Mon, 2008-08-25 at 20:46 +0100, Ian Campbell wrote:
> >  =20
> >> I thought the tools did this (so expected the Lenny tools to be
> >> correct) but looking at the code it seems it is the domain 0 kernel
> >> which does it.
> >>    =20
> >
> > Uh, I'm thinking backwards here. It's the frontend which writes it but
> > the backend needs to understand it which the Etch kernel does not.
> >  =20
>=20
> Should we push that patch back into stable kernels?

The pvops kernel frontend already does the right thing. I'll look into
what it would take to get the support added to the backends in Etch.

Ian.

--=20
Ian Campbell

Matrimony isn't a word, it's a sentence.

--=-On85wWG3bDF4AH4FyklQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkizHAgACgkQM0+0qS9rzVmXTwCfW0dqUO5v+EOQ3+AJYhrArYTX
qkYAoKmvVr1N0b85cgjrsXInYGR5wGeo
=C1dG
-----END PGP SIGNATURE-----

--=-On85wWG3bDF4AH4FyklQ--

