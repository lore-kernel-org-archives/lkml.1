Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbZIVXT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbZIVXT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbZIVXTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:19:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56110 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbZIVXTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:19:25 -0400
Date: Wed, 23 Sep 2009 01:18:39 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: khali@linux-fr.org, jbarnes@virtousgeek.org, linux-pci@vger.kernel.org,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Crash on reading the whole PCI config of PIIX4 SMBus
Message-ID: <20090922231839.GA20656@pengutronix.de>
References: <4AB8F142.9090609@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <4AB8F142.9090609@nachtwindheim.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2009 at 05:46:10PM +0200, Henrik Kretzschmar wrote:

> at boot time my system (Wincor/Nixdorf Beetle D1) sometimes crashs while =
loading the i2c-piix4 driver.

Have you checked if you have the latest BIOS for this machine? Sometimes
PCI-problems got fixed there...

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkq5W08ACgkQD27XaX1/VRtoFwCgrajXb2hYeqEhKYEl3euzitnx
BJYAoMyzKlAC/ZIvDKCkJIJZHZdJP9fX
=dinN
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
