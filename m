Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZJURGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZJURGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 13:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbZJURGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 13:06:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33496 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbZJURGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 13:06:52 -0400
Date: Wed, 21 Oct 2009 19:06:41 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linuxppc-dev@ozlabs.org, David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] powerpc/5200: Add mpc5200-spi (non-PSC) device
	driver
Message-ID: <20091021170641.GA3106@pengutronix.de>
References: <20090618025030.12363.69402.stgit@localhost.localdomain> <20091021131747.GG12819@pengutronix.de> <fa686aa40910210745l7d19d6ecq303ee990bed82c62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <fa686aa40910210745l7d19d6ecq303ee990bed82c62@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> V4 was supposed to go in during the merge window.  But I haven't heard
> anything from David (and I didn't pursue it either).  Unless David
> objects, I'll put it into either my -merge or my -next tree; depending
> on what Ben and Linus prefer.

I wondered if there was going to be a V5 as you said you fixed a few things
according to my review and couldn't find an updated patch for that.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrfP6EACgkQD27XaX1/VRsh3QCePLvQeu0ERCeJvx2l5LrEtDY4
/Q8An1B29qosnUF62OBV3AstrTFxSnJM
=5evQ
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
