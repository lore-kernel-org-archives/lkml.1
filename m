Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbZKZKvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbZKZKvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 05:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZKZKvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 05:51:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60598 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZKZKvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 05:51:06 -0500
Date: Thu, 26 Nov 2009 11:50:32 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: i2c tree build warning
Message-ID: <20091126105032.GA4846@pengutronix.de>
References: <20091126140600.2f55ab0e.sfr@canb.auug.org.au> <20091126091829.74d3b7ce@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <20091126091829.74d3b7ce@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Thanks for reporting. The warning did not show on my 32-bit x86 system,
> and I guess it did not show on Wolfram's system either, otherwise we'd
> have fixed it.

Yes, I tested it on a few embedded boards which are all 32-bit. Will try to=
 get
a 64-bit machine into my test-process. Sorry for this!

Thank you Stephen for reporting and Jean for helping out!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksOXXgACgkQD27XaX1/VRtn8ACeNQ/MkCNAMGZrPh10IitgwX7K
WxMAoIQXNUIBh9RMbJ8iZZ5yOnRO3Zs7
=W+6Y
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
