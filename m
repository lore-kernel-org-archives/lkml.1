Return-Path: <linux-kernel-owner+w=401wt.eu-S1752271AbZJSJkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbZJSJkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 05:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZJSJkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 05:40:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57832 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbZJSJkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 05:40:46 -0400
Date: Mon, 19 Oct 2009 11:40:48 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, gregkh@suse.de,
       linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH] pcmcia: fix controller printk format warnings
Message-ID: <20091019094048.GA3414@pengutronix.de>
References: <4AD28B51.7020903@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <4AD28B51.7020903@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 11, 2009 at 06:50:09PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Fix new pcmcia printk format warnings:
> [This has now moved from linux-next to mainline.
> Originally sent 2009-SEP-17.]
>=20
> drivers/pcmcia/i82365.c:1055: warning: format '%#x' expects type 'unsigne=
d int', but argument 6 has type 'phys_addr_t'
> drivers/pcmcia/i82365.c:1055: warning: format '%#x' expects type 'unsigne=
d int', but argument 7 has type 'phys_addr_t'
> drivers/pcmcia/tcic.c:734: warning: format '%#x' expects type 'unsigned i=
nt', but argument 6 has type 'phys_addr_t'
> drivers/pcmcia/tcic.c:734: warning: format '%#x' expects type 'unsigned i=
nt', but argument 7 has type 'phys_addr_t'
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrcNCAACgkQD27XaX1/VRvmXgCdF0fnnRQ+1V7cHqzJJ8e8IOej
4egAoIB04q+W2SaeHuIn8wNrVHNB1EIS
=d+A4
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
