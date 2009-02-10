Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZBJPQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZBJPQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 10:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbZBJPQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 10:16:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40059 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZBJPQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 10:16:44 -0500
Date: Tue, 10 Feb 2009 16:16:39 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ben-linux@fluff.org, linux-i2c@vger.kernel.org, frank@f-seidel.de,
       "David S. Miller" <davem@davemloft.net>,
       ukleinek@informatik.uni-freiburg.de, Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCHv2 2/2] i2c: adapt debug macros for KERN_* constants
Message-ID: <20090210151639.GB15678@pengutronix.de>
References: <498C3EEA.5060508@suse.de> <498EE9C9.4080002@suse.de> <498EEA2F.5050601@suse.de> <20090209161644.35e3154d@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oC1+HKm2/end4ao3"
Content-Disposition: inline
In-Reply-To: <20090209161644.35e3154d@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Wolfram, I would appreciate if you could test the patch and confirm it
> doesn't break anything:
> ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-=
i2c/i2c-algo-pca-adapt-debug-macros-for-KERN-constants.patch

Will do, but may take until the end of the week. Patch looks good,
though.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--oC1+HKm2/end4ao3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmRmlcACgkQD27XaX1/VRtDIQCeKN51QfbmMMM2NDEKSj9/+jZJ
CqcAnAo0Uw+mrxq/JtTYiJLdGjHa77Ca
=4zoK
-----END PGP SIGNATURE-----

--oC1+HKm2/end4ao3--
