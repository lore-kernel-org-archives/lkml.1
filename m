Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbXFSE5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbXFSE5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 00:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbXFSE5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 00:57:36 -0400
Received: from smtp-0-1.linuxrulz.org ([64.191.81.102]:36125 "EHLO
	smtp-0-1.linuxrulz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbXFSE5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 00:57:35 -0400
Message-ID: <46776223.3050402@lbsd.net>
Date: Tue, 19 Jun 2007 04:57:07 +0000
From: Nigel Kukard <nkukard@lbsd.net>
User-Agent: Thunderbird 2.0.0.0 (X11/20070421)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org
Subject: Re: SATA problems
References: <4671366B.7090702@lbsd.net> <46716B1D.1070902@garzik.org> <20070614182854.GC1223@redhat.com> <20070618200703.GB13344@redhat.com>
In-Reply-To: <20070618200703.GB13344@redhat.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=27702C4E;
	url=pgpkeys.mit.edu
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig84703B0FF467A6D38A9BF72A"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig84703B0FF467A6D38A9BF72A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


>  >=20
>  >  > > Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on =
port
>  >  > > 0x0001c807
>  >  > > Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on =
port
>  >  > > 0x0001c807
>  >=20
>  > Unrelated to the other error, but I've been meaning to ask for a whi=
le..
>  > If this is 'abnormal', why does every SATA box I've seen do it?
>
> *crickets*
>
> Should we check for this case explicitly, and not print this?
>
>  =20
After I get the above errors, my entire SATA bus crashes and I need to
hard reset the box ... not sure we can just ignore the errors?


--------------enig84703B0FF467A6D38A9BF72A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGd2InKoUGSidwLE4RAt7MAKDFWuldh9kJmhSLzYgZAcC4mv5qUQCffyJa
Vrc1m9H9ghukWboDeznowaM=
=Odk2
-----END PGP SIGNATURE-----

--------------enig84703B0FF467A6D38A9BF72A--
