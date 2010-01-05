Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430Ab0AEUWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab0AEUWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023Ab0AEUWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:22:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34341 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab0AEUWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:22:05 -0500
Date: Tue, 5 Jan 2010 21:21:58 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Olof Johansson <olof@lixom.net>
Cc: ben-linux@fluff.org, linux-kernel@vger.kernel.org,
       linux-i2c@vger.kernel.org
Subject: Re: [PATCH] pca953x: Minor include cleanup
Message-ID: <20100105202158.GB4848@pengutronix.de>
References: <20100105201042.GA28367@lixom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline
In-Reply-To: <20100105201042.GA28367@lixom.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 05, 2010 at 02:10:42PM -0600, Olof Johansson wrote:
> linux/i2c/pca953x.h is a very bare include file. Fix check for multiple
> includes of linux/i2c/pca953x.h, and add dependent includes into the
> header file.
>=20
> Signed-off-by: Olof Johansson <olof@lixom.net>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAktDn2UACgkQD27XaX1/VRsDXgCgzAZ3qvy55dm/lmuulhArMrLo
o1UAniXEUstGpNwnYAnkfncXAicdSL9G
=2iJO
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
