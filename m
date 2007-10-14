Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbXJNNbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbXJNNbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 09:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756327AbXJNNbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 09:31:12 -0400
Received: from lug-owl.de ([195.71.106.12]:46336 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbXJNNbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 09:31:11 -0400
Date: Sun, 14 Oct 2007 15:31:09 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Mark Lord <lkml@rtr.ca>
Cc: vignesh babu <vigneshbabu@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: wierd file perms
Message-ID: <20071014133109.GN16774@lug-owl.de>
Mail-Followup-To: Mark Lord <lkml@rtr.ca>,
	vignesh babu <vigneshbabu@gmail.com>, linux-kernel@vger.kernel.org
References: <3d1754a30710131010h5d3cbb28tfeb8b4228a448f2e@mail.gmail.com> <4712199D.6090409@rtr.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O27Gs9jTTFWz3gAR"
Content-Disposition: inline
In-Reply-To: <4712199D.6090409@rtr.ca>
X-Operating-System: Linux mail 2.6.18-5-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--O27Gs9jTTFWz3gAR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-10-14 09:29:01 -0400, Mark Lord <lkml@rtr.ca> wrote:
> vignesh babu wrote:
> ..
> >?--------- ? ? ? ?                ? fcntl.c
> >?--------- ? ? ? ?                ? fifo.c
> >?--------- ? ? ? ?                ? filesystems.c
> >?--------- ? ? ? ?                ? file_table.c
> >?--------- ? ? ? ?                ? freevxfs
> >
> >So end result is that, Im not able to delete the files or change perms
> >or ownership even as root.
> >
> >Can some one help please?
>=20
> chmod a+x name_of_directory
>=20
> Now you can do "ls -l" and "rm" or whatever.

*cough* The original mail you're replying to had this inside:

> > I was hitting another issue with permissions-as root :(                =
                                                    =20

I really think he better starts a fsck... Soon.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
  Signature of:                           Wenn ich wach bin, tr=C3=A4ume ic=
h.
  the second  :

--O27Gs9jTTFWz3gAR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHEhodHb1edYOZ4bsRAgGSAJ9Zwcc9daZyjK31N1J0eD9aizkJSACggRUq
iQDlYpbcOPeXcqDCNGzeqYw=
=kirP
-----END PGP SIGNATURE-----

--O27Gs9jTTFWz3gAR--
