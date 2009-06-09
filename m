Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbZFIAyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbZFIAyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 20:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZFIAyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 20:54:00 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:52982 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbZFIAyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 20:54:00 -0400
Subject: Re: [PATCH 2/2] pnp: add PNP resource range checking function
From: Eric Anholt <eric@anholt.net>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Frans Pop <elendil@planet.nl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, apw@canonical.com,
       colin.king@canonical.com, tim.gardner@canonicalc.com,
       bjorn.helgaas@hp.com
In-Reply-To: <4A2A1AB6.9020808@cs.helsinki.fi>
References: <Pine.LNX.4.64.0906060934500.11247@melkki.cs.Helsinki.FI>
	 <200906060931.36168.elendil@planet.nl>  <4A2A1AB6.9020808@cs.helsinki.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ndn9s4p8ZwjcyQJGUW5l"
Date: Mon, 08 Jun 2009 17:53:59 -0700
Message-Id: <1244508839.7564.0.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ndn9s4p8ZwjcyQJGUW5l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-06-06 at 10:28 +0300, Pekka Enberg wrote:
> Hi Frans,
>=20
> Frans Pop wrote:
> >> Add a PNP resource range check function, indicating whether a resource
> >> has been assigned to any device.
> >=20
> > Shouldn't this patch come *before* your patch 1/2?
> > You now seem to use this function in a commit where it has not yet been=
=20
> > defined, which could result in build errors during bisections.
>=20
> Yes, correct. Sorry about that!
>=20
> 			Pekka

This is already in drm-intel-next

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-Ndn9s4p8ZwjcyQJGUW5l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkotsqUACgkQHUdvYGzw6veuBwCfZRIaHc7fSUHMByLSJmOZVm4b
dCIAoJITxj3HxQe3UWioIHiKv9fIS1bO
=hm/B
-----END PGP SIGNATURE-----

--=-Ndn9s4p8ZwjcyQJGUW5l--

