Return-Path: <linux-kernel-owner+w=401wt.eu-S1761935AbXJMR4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761935AbXJMR4L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 13:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbXJMRz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 13:55:58 -0400
Received: from lug-owl.de ([195.71.106.12]:54553 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756694AbXJMRz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 13:55:57 -0400
X-Greylist: delayed 1628 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Oct 2007 13:55:57 EDT
Date: Sat, 13 Oct 2007 19:28:48 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: vignesh babu <vigneshbabu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: wierd file perms
Message-ID: <20071013172848.GE16774@lug-owl.de>
Mail-Followup-To: vignesh babu <vigneshbabu@gmail.com>,
	linux-kernel@vger.kernel.org
References: <3d1754a30710131010h5d3cbb28tfeb8b4228a448f2e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AjmyJqqohANyBN/e"
Content-Disposition: inline
In-Reply-To: <3d1754a30710131010h5d3cbb28tfeb8b4228a448f2e@mail.gmail.com>
X-Operating-System: Linux mail 2.6.18-5-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--AjmyJqqohANyBN/e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-13 22:40:23 +0530, vignesh babu <vigneshbabu@gmail.com> wro=
te:
>=20
> I was surprised and did an ls -l on the files and guess what I found:
>=20
> total 0
> ?--------- ? ? ? ?                ? fcntl.c
> ?--------- ? ? ? ?                ? fifo.c
> ?--------- ? ? ? ?                ? filesystems.c
> ?--------- ? ? ? ?                ? file_table.c
> ?--------- ? ? ? ?                ? freevxfs
>=20
> So end result is that, Im not able to delete the files or change perms
> or ownership even as root.

Most probably, your filesystem is broken and needs a fsck.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
  Signature of:                          Zensur im Internet? Nein danke!
  the second  :

--AjmyJqqohANyBN/e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHEQBQHb1edYOZ4bsRAkeeAJ9pTWMNzy2IlciSU9GMPNd457mZMwCeMGyK
jQfERaWAGQyt2locluYzqBI=
=Zx9i
-----END PGP SIGNATURE-----

--AjmyJqqohANyBN/e--
