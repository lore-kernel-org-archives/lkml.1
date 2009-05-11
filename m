Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbZEKOQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbZEKOQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZEKOP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:15:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58669 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbZEKOP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:15:56 -0400
Date: Mon, 11 May 2009 16:15:48 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: =?utf-8?B?5LyK5rO9?= <wxc200@gmail.com>,
       Mark Brown <broonie@sirena.org.uk>, linux-i2c@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.29.2] PXA I2C: Define log level for i2c PXA error
	report
Message-ID: <20090511141548.GB3061@pengutronix.de>
References: <Pine.LNX.4.64.0905060829580.24668@venus.araneidae.co.uk> <20090506102202.73d6045d@hyperion.delvare> <Pine.LNX.4.64.0905081102060.14384@venus.araneidae.co.uk> <fd6b62c10905110311w6350828tf90d9c699b73fe30@mail.gmail.com> <Pine.LNX.4.64.0905111126020.20970@venus.araneidae.co.uk> <20090511112801.GA20283@sirena.org.uk> <fd6b62c10905110629w6c9a641fr878351fb9217a32e@mail.gmail.com> <Pine.LNX.4.64.0905111458290.6308@venus.araneidae.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yNb1oOkm5a9FJOVX"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905111458290.6308@venus.araneidae.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Still, I think it would make more sense for these to be one-liners; I=20
> guess routine probing failures ought to be reported in a slightly=20
> different way.  I'll see if I can figure out a sensible patch.

You might want to have a look here as I also noted once that the
pxa-driver is a bit too talkative when writing to eeproms:

http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg00324.html

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--yNb1oOkm5a9FJOVX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoIMxQACgkQD27XaX1/VRuPPQCgtgP964CKO9ddCoSuMZARNDS9
0FQAoINYFGY3iF5BXBLl2BIdklr/kT7o
=U1mc
-----END PGP SIGNATURE-----

--yNb1oOkm5a9FJOVX--
