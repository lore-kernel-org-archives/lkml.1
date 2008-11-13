Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbYKMWzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbYKMWzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYKMWzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:55:46 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:54306 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbYKMWzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:55:45 -0500
Date: Thu, 13 Nov 2008 23:55:40 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: petkovbb@gmail.com
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] checkpatch: Add warning for p0-patches
Message-ID: <20081113225540.GA11912@pengutronix.de>
References: <1225467370-19143-1-git-send-email-w.sang@pengutronix.de> <20081112135522.GD8302@shadowen.org> <9ea470500811120623q4334f840t4540649edba935@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <9ea470500811120623q4334f840t4540649edba935@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:3:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Boris,

> files. Well, this one suffers from the exact opposite problem - it won't =
trigger
> even if it is a -p0 patch on new files, AFAICT.

Can you give an example, please? I fail to see this at the moment.

All the best,

   Wolfram

--=20
  Dipl.-Ing. Wolfram Sang | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkcsGwACgkQD27XaX1/VRttWQCffts0k5gNiorAoR/jNS16VC7Y
NpwAoIIXvwHsyXQs4Uho6yxqb3JCXdgo
=fsve
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
