Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbZIWQNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbZIWQNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZIWQNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:13:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40152 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZIWQNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:13:37 -0400
Date: Wed, 23 Sep 2009 18:13:40 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [RFC] regulator: add driver for MAX8660/8661
Message-ID: <20090923161340.GE3131@pengutronix.de>
References: <1253625499-9314-1-git-send-email-w.sang@pengutronix.de> <20090922191529.GB4690@sirena.org.uk> <20090923151538.GD3131@pengutronix.de> <20090923160556.GA8593@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C94crkcyjafcjHxo"
Content-Disposition: inline
In-Reply-To: <20090923160556.GA8593@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C94crkcyjafcjHxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Any references?  I did search the datasheet for at least one of the
> parts before asking but didn't turn anything up.

Page 34 mentions it in Register 0x80 and points to the section "Ramp Rate
Control", page 28f.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--C94crkcyjafcjHxo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkq6STQACgkQD27XaX1/VRsURwCeOkd9ibObBg0ketWCnyeKtAgm
VK8AoLrtXyig2G+dKhDKPMNhYa46po7c
=XOxC
-----END PGP SIGNATURE-----

--C94crkcyjafcjHxo--
