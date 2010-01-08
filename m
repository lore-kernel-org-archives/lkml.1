Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106Ab0AHV0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0AHV0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 16:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930Ab0AHV0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 16:26:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53126 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab0AHV0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 16:26:08 -0500
Date: Fri, 8 Jan 2010 22:26:03 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
       Richard Zhao <linuxzsc@gmail.com>,
       Darius Augulis <augulis.darius@gmail.com>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c/imx: call ioremap only after request_mem_region
Message-ID: <20100108212603.GC31747@pengutronix.de>
References: <1262967797-2001-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vOmOzSkFvhd7u8Ms"
Content-Disposition: inline
In-Reply-To: <1262967797-2001-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 08, 2010 at 05:23:17PM +0100, Uwe Kleine-K=F6nig wrote:
> accordingly adapt order of release_mem_region and release_mem_region on
> remove.
>=20
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--vOmOzSkFvhd7u8Ms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAktHousACgkQD27XaX1/VRtDXgCgqhrnhREBhUAVwKx/YXn9mDth
3/0AoKRceMzo3q9oK5P8oV7PxtIggdj6
=X4KS
-----END PGP SIGNATURE-----

--vOmOzSkFvhd7u8Ms--
