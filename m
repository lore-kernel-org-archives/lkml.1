Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbZIFRlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbZIFRlm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 13:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbZIFRli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 13:41:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53769 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZIFRlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 13:41:37 -0400
Date: Sun, 6 Sep 2009 19:41:36 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Christian =?iso-8859-15?Q?Kr=E4mer?= <christian@kraemer-eu.de>
Cc: Frans Pop <elendil@planet.nl>, linux-pcmcia@lists.infradead.org,
       Peter Stuge <peter@stuge.se>, linux-kernel@vger.kernel.org
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Message-ID: <20090906174136.GA8224@pengutronix.de>
References: <200909021856.29565.christian@kraemer-eu.de> <200909042239.17180.christian@kraemer-eu.de> <20090905143022.GD3171@pengutronix.de> <200909052146.10779.christian@kraemer-eu.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <200909052146.10779.christian@kraemer-eu.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Uh oh. Which BIOS version do you have?
>=20
> The configuration interface displays: IBET41WW, 05/12/99.
> I know this isn't the newest version, but I don't have a floppy device fo=
r the
> laptop. I'll try to brun a dos cd with el torito folppy emulation, maybe =
i can
> upgrade it this way.

Given the various issues this laptop has, this is worthwhile, me thinks.

> Strange, I'dont use a docking station. I have not even got one.

Okay, then it is just a bay.

> > To make sure: Do regular PC Cards (non-CardBus) work with/without the
> > docking station? (I would assume that...)
>=20
> With regular PC Cards you mean 16 bit cards, don't you? I have only those=
 one
> wlan card, but i can try to organisate one.

Yup, I mean those. That would sort out that the TI-Controller is broken. But
there is more likely something wrong with the PCI-setup.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqj9FAACgkQD27XaX1/VRvyGQCghSfqH6e+dL5zPvPL9VuRV217
f20An2FtRT+YDPnvPIPZ4lLiuxM9Yi19
=r/ke
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
