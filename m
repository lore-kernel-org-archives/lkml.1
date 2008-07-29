Return-Path: <linux-kernel-owner+w=401wt.eu-S1759486AbYG2WeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbYG2WeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbYG2WeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:34:12 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:54122
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755288AbYG2WeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:34:11 -0400
Date: Tue, 29 Jul 2008 15:33:46 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Alex Buell <alex.buell@munted.org.uk>
Cc: Robert Hancock <hancockr@shaw.ca>, usb-storage@lists.one-eyed-alien.net,
       Tomas Styblo <tripie@cpan.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [usb-storage] [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device 152d:2338
Message-ID: <20080729223346.GE6091@one-eyed-alien.net>
Mail-Followup-To: Alex Buell <alex.buell@munted.org.uk>,
	Robert Hancock <hancockr@shaw.ca>,
	usb-storage@lists.one-eyed-alien.net,
	Tomas Styblo <tripie@cpan.org>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <fa.eWQqoO1e4Mdhu8SK5jzMFAI/3NU@ifi.uio.no> <4884E585.2050104@shaw.ca> <20080722051110.GA8303@notebook.homenet.local> <488570A5.8000602@shaw.ca> <20080722061147.GB8303@notebook.homenet.local> <48859E2C.4070805@shaw.ca> <20080729220908.8b698469.alex.buell@munted.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20080729220908.8b698469.alex.buell@munted.org.uk>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Tue, 29 Jul 2008 15:33:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2008 at 10:09:08PM +0100, Alex Buell wrote:
> On Tue, 22 Jul 2008 02:45:32 -0600, I waved a wand and this message
> magically appears in front of Robert Hancock:
>=20
> > I suppose it wouldn't hurt to let JMicron know about this. I doubt
> > they could do anything for existing chipsets, but it might help them
> > avoid this bug in future designs.
>=20
> I can reproduce this EVERY time with SATA disks using the same JM20337
> chipset.=20
>=20
> 1. mke2fs /dev/sda1
> 2. tunefs -j /dev/sda1
> 3. e2fsck /dev/sda1

I already sent a note to my contact at JMicron, but got no response.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Somebody call an exorcist!
					-- Dust Puppy
User Friendly, 5/16/1998

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIj5rKHL9iwnUZqnkRAnhUAJ4pQgFMWpRUyrtyLsXwPfA1BKJFUgCfaMSF
mjLW3cMJQA7cLmZ2cJ4ziR8=
=g3jD
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
