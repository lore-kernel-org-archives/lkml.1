Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbYG0GJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbYG0GJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbYG0GJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:09:41 -0400
Received: from mail11.tpgi.com.au ([203.12.160.161]:60554 "EHLO
	mail11.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYG0GJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:09:41 -0400
X-TPG-Antivirus: Passed
Date: Sun, 27 Jul 2008 16:07:01 +1000
From: Alex Samad <alex@samad.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: page swap allocation error/failure in 2.6.25
Message-ID: <20080727060701.GA7157@samad.com.au>
References: <20080725072015.GA17688@samad.com.au> <1216971601.7257.345.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <1216971601.7257.345.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2008 at 09:40:01AM +0200, Peter Zijlstra wrote:
> On Fri, 2008-07-25 at 17:20 +1000, Alex Samad wrote:
> > Hi

[snip]

>=20
>=20
> Its harmless if it happens sporadically.=20
>=20
> Atomic order 2 allocations are just bound to go wrong under pressure.
can you point me to any doco that explains this ?

>=20
>=20

--=20
"I'm honored to shake the hand of a brave Iraqi citizen who had his hand cu=
t off by Saddam Hussein."

	- George W. Bush
05/25/2004
Washington, DC

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiMEIEACgkQkZz88chpJ2M67wCeIxIT1oCZbjaEmilSq3X9OeRY
YbMAoI1xIl2ydCevTqEOzJzYe1S505Ey
=bEg2
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
