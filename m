Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbYDCPta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbYDCPta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760272AbYDCPtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:49:18 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:52227
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760260AbYDCPtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:49:17 -0400
Date: Thu, 3 Apr 2008 08:48:45 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Mark Lord <lkml@rtr.ca>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: ASUS ScreenDuo
Message-ID: <20080403154845.GA11683@one-eyed-alien.net>
Mail-Followup-To: Xavier Bestel <xavier.bestel@free.fr>,
	Mark Lord <lkml@rtr.ca>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1207230481.24037.11.camel@skunk.anacadf.mentorg.com> <47F4E234.9000308@rtr.ca> <1207231628.3438.6.camel@skunk.anacadf.mentorg.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <1207231628.3438.6.camel@skunk.anacadf.mentorg.com>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Thu, 03 Apr 2008 08:48:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 03, 2008 at 04:07:08PM +0200, Xavier Bestel wrote:
> On Thu, 2008-04-03 at 09:57 -0400, Mark Lord wrote:
> > > [root@awak:~]$ fdisk /dev/sdc
> > >=20
> > > Unable to open /dev/sdc
> > >=20
> > ..
> >=20
> > As root, try:   mknod /tmp/sdc b 8 32 ; fdisk /tmp/sdc
> >=20
> > Any different?=20
>=20
> Nope. But /dev/sdc has already been created, and looks right (b 8 32
> too). Just there's nothing behind it.

Turn on CONFIG_USB_STORAGE_DEBUG and see what logs it generates when you
try to access the device.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

NYET! The evil stops here!
					-- Pitr
User Friendly, 6/22/1998

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFH9PxdHL9iwnUZqnkRAgtiAJ9QR0u9/FNPXYW6eDGF9Xo4qtaTVQCeKSxl
gsRkQHi8S7l1/QeHBbktoBc=
=xmNB
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
