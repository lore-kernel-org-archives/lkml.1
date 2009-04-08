Return-Path: <linux-kernel-owner+w=401wt.eu-S1760425AbZDHIEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425AbZDHIEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbZDHIEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:04:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58298 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbZDHIEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:04:08 -0400
Date: Wed, 8 Apr 2009 10:03:56 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
       Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: [GIT PULL] i2c updates for 2.6.30
Message-ID: <20090408080356.GA3072@pengutronix.de>
References: <20090328213950.1c788471@hyperion.delvare> <10f740e80904071320t2fdd073bs51f3a8abf0f60e36@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <10f740e80904071320t2fdd073bs51f3a8abf0f60e36@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> drivers/i2c/algos/i2c-algo-pca.c:197: warning: 'state' is used
> uninitialized in this function

ACK. Will send a patch in a minute. Thanks for reporting!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkncWmwACgkQD27XaX1/VRvhCwCeObGNPu8Uoq0aA8+ST0qJYYy8
J/gAn24C55RytbxTtWYnEVZZztPpvXYN
=+hAI
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
