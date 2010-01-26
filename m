Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197Ab0AZPiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0AZPiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 10:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813Ab0AZPiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 10:38:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53119 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab0AZPiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 10:38:08 -0500
Date: Tue, 26 Jan 2010 16:37:59 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>,
       Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add i2c tree for embedded platforms
Message-ID: <20100126153759.GF4431@pengutronix.de>
References: <1264411234-5400-1-git-send-email-u.kleine-koenig@pengutronix.de> <20100125111055.05ccedf2@hyperion.delvare> <20100126143830.GC12774@fluff.org.uk> <20100126162515.230bdf36@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HCdXmnRlPgeNBad2"
Content-Disposition: inline
In-Reply-To: <20100126162515.230bdf36@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HCdXmnRlPgeNBad2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> So I see no objection to a mass move of all embedded/system i2c bus
> drivers to a separate sub-directory.

And with the PCA9xxx-controllers? The ISA-driver into non-embedded and the
platform-driver into embedded? Hmmm...

And (in 80 years ;)) there might be just one I2C-maintainer taking care of =
them
all? Then, why the split?

I am all for taking the embedded-burden away from you, just I am not too fo=
nd
of this idea.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--HCdXmnRlPgeNBad2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAktfDFcACgkQD27XaX1/VRvBdACdGcOB7kKbnYutaSkD/VYAGuDg
lOUAnjCn6z2Zpug5h1anrHaQu1/eOLhE
=wUUR
-----END PGP SIGNATURE-----

--HCdXmnRlPgeNBad2--
