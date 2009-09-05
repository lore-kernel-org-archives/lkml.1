Return-Path: <linux-kernel-owner+w=401wt.eu-S1752015AbZIEOEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbZIEOEw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 10:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbZIEOEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 10:04:51 -0400
Received: from foo.birdnet.se ([213.88.146.6]:55710 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751502AbZIEOEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 10:04:51 -0400
Message-ID: <20090905140447.10120.qmail@stuge.se>
Date: Sat, 5 Sep 2009 16:04:47 +0200
From: Peter Stuge <peter@stuge.se>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Christian =?utf-8?Q?Kr=C3=A4mer?= <christian@kraemer-eu.de>,
       Frans Pop <elendil@planet.nl>, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Mail-Followup-To: Wolfram Sang <w.sang@pengutronix.de>,
	Christian =?utf-8?Q?Kr=C3=A4mer?= <christian@kraemer-eu.de>,
	Frans Pop <elendil@planet.nl>, linux-pcmcia@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <200909021856.29565.christian@kraemer-eu.de> <200909031927.19590.elendil@planet.nl> <20090903193709.GA11097@pengutronix.de> <200909040149.45066.christian@kraemer-eu.de> <20090905135911.GC3171@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LiQwW4YX+w4axhAx"
Content-Disposition: inline
In-Reply-To: <20090905135911.GC3171@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LiQwW4YX+w4axhAx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Wolfram Sang wrote:
> Well, the PCI config space (which lspci needs) should be visible
> without an assigned IRQ.

There is some issue (only? also?) with the bridge.


//Peter

--LiQwW4YX+w4axhAx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFKom//hR3Q0dhIfEgRAvGzAKCpCrLYdlPLV+MUDVWUx5nz8pgOcwCg7Iuz
jHy3n50pClPHTKq996zurMI=
=anxJ
-----END PGP SIGNATURE-----

--LiQwW4YX+w4axhAx--
