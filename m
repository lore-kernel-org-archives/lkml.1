Return-Path: <linux-kernel-owner+w=401wt.eu-S1764827AbYEFPlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764827AbYEFPlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbYEFPlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:41:00 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:59822 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755992AbYEFPk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:40:59 -0400
Date: Tue, 6 May 2008 17:40:54 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jochen Friedrich <jochen@scram.de>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       Scott Wood <scottwood@freescale.com>, Linux I2C <i2c@lm-sensors.org>
Subject: Re: [i2c] [PATCH6/7] i2c: adds support for i2c bus on Freescale
	CPM1/CPM2 controllers
Message-ID: <20080506154054.GC4265@pengutronix.de>
References: <47FF71A9.4010907@scram.de> <20080506135113.GA4265@pengutronix.de> <4820770B.1010002@scram.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iFRdW5/EC4oqxDHL"
Content-Disposition: inline
In-Reply-To: <4820770B.1010002@scram.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 10.1.0.71
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 06, 2008 at 05:19:39PM +0200, Jochen Friedrich wrote:
> setbits8() and clrbits8() use a bitmask as second argument.
Ouch! Guess my mind wanted to read in_8 and out_8 for some reason...
Sorry and thanks for clarifying!

   Wolfram

--=20
  Dipl.-Ing. Wolfram Sang | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry

--iFRdW5/EC4oqxDHL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIIHwGD27XaX1/VRsRAgMAAKCuMHYpHITge6JsAJL5zq3rxHWDzACeLVXM
EYriBQiZ3qWFJdwjM5mfXC8=
=zDgZ
-----END PGP SIGNATURE-----

--iFRdW5/EC4oqxDHL--
