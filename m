Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbYBDIPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbYBDIPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 03:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYBDIP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 03:15:29 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:47179
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178AbYBDIP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 03:15:28 -0500
Date: Mon, 4 Feb 2008 00:15:08 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Greg KH <greg@kroah.com>
Cc: Patrick Ringl <patrick_@freenet.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-storage@vger.kernel.org
Subject: Re: wrong cylinders of kingston usb pendrive [intel 82801DB]
Message-ID: <20080204081508.GB14573@one-eyed-alien.net>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Patrick Ringl <patrick_@freenet.de>, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-storage@vger.kernel.org
References: <47A6615D.9090201@freenet.de> <20080204015937.GA16989@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Content-Disposition: inline
In-Reply-To: <20080204015937.GA16989@kroah.com>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Mon, 04 Feb 2008 00:15:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 03, 2008 at 05:59:38PM -0800, Greg KH wrote:
> On Mon, Feb 04, 2008 at 01:50:37AM +0100, Patrick Ringl wrote:
> > Hello,
> >
> > I am suffering from the following (usb-related?) problem:
> >
> > I have several different mashines - all x86 architecture - just lets ca=
ll=20
> > them mashineA, mashineB and mashineC.
>=20
> Is the kernel the same on all of these machines?

I'm not sure it matters...

usb-storage has no knowledge of CHS geometery.  It deals entirely in LBA.

Does anyone know where the kernel gets the CHS geometery equivalent from?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

E:  You run this ship with Windows?!  YOU IDIOT!
L:  Give me a break, it came bundled with the computer!
					-- ESR and Lan Solaris
User Friendly, 12/8/1998

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHpsmMHL9iwnUZqnkRAmn3AKCYkH3bto+6d47QtsMKPQzPSNWCzQCgkK24
sg41xExBEemzEUEDgPdTI4w=
=nMVL
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
