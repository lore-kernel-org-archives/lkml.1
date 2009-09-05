Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbZIEPny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbZIEPny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 11:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZIEPnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 11:43:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35997 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbZIEPnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 11:43:52 -0400
Date: Sat, 5 Sep 2009 17:43:53 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Christian =?iso-8859-15?Q?Kr=E4mer?= <christian@kraemer-eu.de>,
       Frans Pop <elendil@planet.nl>, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Message-ID: <20090905154353.GA3668@pengutronix.de>
References: <200909021856.29565.christian@kraemer-eu.de> <200909031927.19590.elendil@planet.nl> <20090903193709.GA11097@pengutronix.de> <200909040149.45066.christian@kraemer-eu.de> <20090905135911.GC3171@pengutronix.de> <20090905140447.10120.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <20090905140447.10120.qmail@stuge.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Well, the PCI config space (which lspci needs) should be visible
> > without an assigned IRQ.
>=20
> There is some issue (only? also?) with the bridge.

Yes, my sentence was intended to back you up on this :) Could have been more
clear, perhaps...

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqihzkACgkQD27XaX1/VRs1sgCgvl4y86lISGwlsyguKZRYrFAc
vIUAn0LoVbR9CN6TnSmB0G/H9pwR9DCp
=WGiT
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
