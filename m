Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbYL2Tks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbYL2Tks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 14:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYL2Tki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 14:40:38 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:49958
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243AbYL2Tki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 14:40:38 -0500
X-Greylist: delayed 953 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2008 14:40:38 EST
Date: Mon, 29 Dec 2008 11:24:31 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: matthieu castet <castet.matthieu@free.fr>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
       linux-usb@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH -stable] fix USB_STORAGE_CYPRESS_ATACB
Message-ID: <20081229192431.GZ1469@one-eyed-alien.net>
Mail-Followup-To: matthieu castet <castet.matthieu@free.fr>,
	LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
	linux-usb@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
References: <495913A6.9070007@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bpVaumkpfGNUagdU"
Content-Disposition: inline
In-Reply-To: <495913A6.9070007@free.fr>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Mon, 29 Dec 2008 11:24:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bpVaumkpfGNUagdU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Boaz, what's your take on this?  It "feels" to me like this should be fixed
another way, rather than mucking directly with the srb structures.

Matt

On Mon, Dec 29, 2008 at 07:15:02PM +0100, matthieu castet wrote:
> Hi,
>=20
> 64a87b244b9297667ca80264aab849a36f494884 broke USB_STORAGE_CYPRESS_ATACB=
=20
> translation.
>=20
> Could it be applied to kernel-stable ?
>=20
> Matthieu



--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I think the problem is there's a nut loose on your keyboard.
					-- Greg to Customer
User Friendly, 1/5/1999=20

--bpVaumkpfGNUagdU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFJWSPvHL9iwnUZqnkRApcpAKCuueJNglZZFu+e6c5CEhQwrUv3dACfYvp9
7jezillomwG08pFB0io3ia0=
=Hfei
-----END PGP SIGNATURE-----

--bpVaumkpfGNUagdU--
