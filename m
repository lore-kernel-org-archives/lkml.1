Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbZIEN7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbZIEN7L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 09:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbZIEN7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 09:59:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36844 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbZIEN7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 09:59:10 -0400
Date: Sat, 5 Sep 2009 15:59:11 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Christian =?iso-8859-15?Q?Kr=E4mer?= <christian@kraemer-eu.de>
Cc: linux-pcmcia@lists.infradead.org, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Message-ID: <20090905135911.GC3171@pengutronix.de>
References: <200909021856.29565.christian@kraemer-eu.de> <200909031927.19590.elendil@planet.nl> <20090903193709.GA11097@pengutronix.de> <200909040149.45066.christian@kraemer-eu.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Content-Disposition: inline
In-Reply-To: <200909040149.45066.christian@kraemer-eu.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> For this laptop at all there are a lot of problems with newer linux kerne=
ls.=20
> Some people got it working with serveral hacks in the config file of the=
=20
> pcmcia_cs suite, but all those tips only fit with pcmcia_cs and so to the=
=20
> 2.4 kernel. If you're interessted in those sources, i could search the UR=
Ls
> again in my browser history.

Yes, maybe those explain the problem; that would definately help ;)

> Maybe it also relevant what I read on a german bsd-board. In FreeBSD 4.10=
 it=20
> worked perfectly on this laptop, but since 4.11 the slots won't get an=20
> interrupt assigned. I don't now very much about hardware and driver=20
> development, but I'am sure that it has to do something with the assigned=
=20
> ressources (and maybe with the interrupt).

Well, the PCI config space (which lspci needs) should be visible without an
assigned IRQ.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqibq8ACgkQD27XaX1/VRswAQCfak97NYKwra54Eibw/EVpxk1E
TYgAn0dPmhwBS+U3QXQBY551A/otxOkT
=pASz
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--
