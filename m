Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYHZGGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYHZGGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 02:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYHZGGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 02:06:45 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:29806 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948AbYHZGGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 02:06:44 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Sally-Anne Edwards <sallyanne.edwards@googlemail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48B31D3D.1080701@goop.org>
References: <39fd98ca0808240801x7edbe0e6gf242f08de88cd92c@mail.gmail.com>
	 <39fd98ca0808240804p454faff9u289abfc074dbea3@mail.gmail.com>
	 <48B3099E.3060407@goop.org>
	 <1219693601.27921.172.camel@localhost.localdomain>
	 <1219695753.27921.175.camel@localhost.localdomain>
	 <48B31D3D.1080701@goop.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FcTr+WSrtIGg4u81UREo"
Date: Tue, 26 Aug 2008 07:06:31 +0100
Message-Id: <1219730792.27921.180.camel@localhost.localdomain>
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


--=-FcTr+WSrtIGg4u81UREo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-25 at 13:59 -0700, Jeremy Fitzhardinge wrote:
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
> >
> > Unfortunately this means that writing the protocol node as I suggest
> > won't work.
> >
> > Only thing I can recommend at the moment is to use a kernel which does
> > have this (i.e. one from
> > http://xenbits.xensource.com/linux-2.6.18-xen.hg) or to use a 32 bit
> > Etch kernel if you want to run 32 bit guests.
>=20
> Or run a 64-bit domU kernel?  Should work fine with a 32-bit userspace.

Unfortunately Debian has settled on 2.6.26 for the Lenny release so no
64 bit support.

Ian.

--=20
Ian Campbell

Look, we play the Star Spangled Banner before every game.  You want us
to pay income taxes, too?
		-- Bill Veeck, Chicago White Sox

--=-FcTr+WSrtIGg4u81UREo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkiznWcACgkQM0+0qS9rzVkJSgCeKxawHL+53YXiU5mzZJxbg8zV
gYkAnRsWyoK6lKxDRM9BZoblpdThm6iy
=BC8V
-----END PGP SIGNATURE-----

--=-FcTr+WSrtIGg4u81UREo--

