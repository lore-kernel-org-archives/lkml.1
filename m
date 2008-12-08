Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbYLHHck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbYLHHck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 02:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYLHHcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 02:32:31 -0500
Received: from molly.corsac.net ([81.57.48.219]:53826 "EHLO molly.corsac.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbYLHHca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 02:32:30 -0500
Subject: Re: [Bug #12152] Huge wakeups number from i1915
From: Yves-Alexis Perez <corsac@debian.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <200812080828.07683.rjw@sisk.pl>
References: <6VnlupFpCsN.A.2rE.MsEPJB@chimera>
	 <20081207151203.46c01a0d@infradead.org> <1228717448.9677.3.camel@hidalgo>
	 <200812080828.07683.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TwdT5fByN8yQ41Zn3B6a"
Date: Mon, 08 Dec 2008 08:32:41 +0100
Message-Id: <1228721561.9677.18.camel@hidalgo>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TwdT5fByN8yQ41Zn3B6a
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On lun, 2008-12-08 at 08:28 +0100, Rafael J. Wysocki wrote:
> Any pointers to the patch, please?

The patch I had success with was the one enabling MSI on 965. You can
find it there:

http://marc.info/?l=3Ddri-devel&m=3D122843874524733&w=3D2

Not sure if it's =E2=80=9Cthe one=E2=80=9D really usable, but at least it f=
ixes the
problem for now.

Cheers,
--=20
Yves-Alexis

--=-TwdT5fByN8yQ41Zn3B6a
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk8zZkACgkQTUTAIMXAW677LwCePCGfJO4T6hMLs9lw8FtYTwkw
xbkAn09mjeBuoljT8aFoh+cRzqfNtQiX
=wCHH
-----END PGP SIGNATURE-----

--=-TwdT5fByN8yQ41Zn3B6a--
