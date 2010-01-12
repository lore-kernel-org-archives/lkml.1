Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918Ab0ALJH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0ALJH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821Ab0ALJHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:07:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50310 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab0ALJHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:07:54 -0500
Date: Tue, 12 Jan 2010 10:07:41 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: =?iso-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: linux-pcmcia@lists.infradead.org, Julia Lawall <julia@diku.dk>,
       LKML <linux-kernel@vger.kernel.org>, cocci@diku.dk
Subject: Re: [PATCH] pcmcia: make Open Firmware device id constant
Message-ID: <20100112090741.GA3488@pengutronix.de>
References: <4B4C2B1D.9030401@freemail.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <4B4C2B1D.9030401@freemail.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 12, 2010 at 08:56:13AM +0100, N=E9meth M=E1rton wrote:
> From: M=E1rton N=E9meth <nm127@freemail.hu>
>=20
> The match_table field of the struct of_device_id is constant in <linux/of=
_platform.h>
> so it is worth to make the initialization data also constant.
[...]
> Signed-off-by: M=E1rton N=E9meth <nm127@freemail.hu>
> Cc: Julia Lawall <julia@diku.dk>
> Cc: cocci@diku.dk

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAktMO90ACgkQD27XaX1/VRvbTQCgu3rQKM2Dbdc4MVgUYygMTPR3
QFsAn0GybD/Ofa71Erm9wZQeTfn/ndq3
=w6jh
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
