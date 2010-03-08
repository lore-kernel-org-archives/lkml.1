Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0CHECW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 23:02:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40710 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab0CHECR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 23:02:17 -0500
Date: Mon, 8 Mar 2010 05:02:13 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Dan Carpenter <error27@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Julia Lawall <julia@diku.dk>, Dmitry Torokhov <dtor@mail.ru>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] regulator: handle kcalloc() failure
Message-ID: <20100308040213.GI8548@pengutronix.de>
References: <20100307123645.GB6469@bicker>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cVp8NMj01v+Em8Se"
Content-Disposition: inline
In-Reply-To: <20100307123645.GB6469@bicker>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cVp8NMj01v+Em8Se
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 07, 2010 at 03:36:45PM +0300, Dan Carpenter wrote:
> Return -ENOMEM if kcalloc() fails
>=20
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--cVp8NMj01v+Em8Se
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuUdsUACgkQD27XaX1/VRtE4gCguQme9vkTrK7Ww6xVRphvsqkZ
qBkAmgM2i1HCenHtTlQ2P+y/iTluAxbk
=UZGt
-----END PGP SIGNATURE-----

--cVp8NMj01v+Em8Se--
