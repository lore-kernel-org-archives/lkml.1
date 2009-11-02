Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbZKBAuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbZKBAuE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 19:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbZKBAuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 19:50:03 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:59425
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbZKBAuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 19:50:02 -0500
Date: Sun, 1 Nov 2009 16:49:40 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, nut-upsuser@lists.alioth.debian.org,
       bruce.w.allan@intel.com, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.31.4: Intel P55 Chipset BUG [usbhid-raw/devices/broken?] [tested 3 different UPS']
Message-ID: <20091102004940.GD24436@one-eyed-alien.net>
Mail-Followup-To: Justin Piszcz <jpiszcz@lucidpixels.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	nut-upsuser@lists.alioth.debian.org, bruce.w.allan@intel.com,
	Alan Piszcz <ap@solarrain.com>
References: <alpine.DEB.2.00.0910311847530.5522@p34.internal.lan> <Pine.LNX.4.44L0.0911011151270.399-100000@netrider.rowland.org> <20091101175216.GA24436@one-eyed-alien.net> <alpine.DEB.2.00.0911011613270.2767@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BRE3mIcgqKzpedwo"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0911011613270.2767@p34.internal.lan>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2009 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Sun, 01 Nov 2009 16:49:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BRE3mIcgqKzpedwo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 01, 2009 at 04:18:40PM -0500, Justin Piszcz wrote:
>=20
> I do not use any hubs in this environment, everything is directly=20
> attached to the motheboard.  Per Matthew (noted below) when I
> mention hub I am talking about your typical USB hub one would
> attach to a USB port on the board, not the integrated one on the
> motherboard.  Everything is directly attached from the motherboard
> to each respective device.
>=20
> MOBO -> UPS
> MOBO -> KBD
> MOBO -> etc

Just to be clear, the hub isn't "on the motherboard".  It's actually in the
P55 silicon itself.  It's not a separate chip or anything; it's part of the
PCH design.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

You are needink to look more evil.  You likink very strong coffee?
					-- Pitr to Dust Puppy
User Friendly, 10/16/1998

--BRE3mIcgqKzpedwo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFK7iykHL9iwnUZqnkRAu7NAJ90m4im0hfCmQCt9wXSiLBC/6DJRQCeKQu4
B/oq6+6n/dOdQILOFlCow9c=
=kIiC
-----END PGP SIGNATURE-----

--BRE3mIcgqKzpedwo--
