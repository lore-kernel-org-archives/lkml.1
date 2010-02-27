Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030700Ab0B0TMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 14:12:09 -0500
Received: from mail.ipom.com ([74.207.225.167]:52136 "EHLO mail.ipom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030688Ab0B0TMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 14:12:07 -0500
Message-ID: <4B896E79.6090302@ipom.com>
Date: Sat, 27 Feb 2010 20:11:53 +0100
From: Phil Dibowitz <phil@ipom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100216 Thunderbird/3.0.2
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>,
       usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [usb-storage] [PATCH] [resend] unusual_devs.h: Fix capacity for
 SL11R-IDE 2.6c
References: <201002241141.10103.linux@rainbow-software.org> <20100224192959.GJ20232@one-eyed-alien.net> <201002242222.21008.linux@rainbow-software.org> <20100224224739.GK20232@one-eyed-alien.net>
In-Reply-To: <20100224224739.GK20232@one-eyed-alien.net>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE69A08CAF5F20AD50FE32287"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE69A08CAF5F20AD50FE32287
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/24/2010 11:47 PM, Matthew Dharm wrote:
> Phil D. --
>=20
> I recommend circling around with pwaechtler@loewe-komp.de to see if we
> can't condense these into a single entry.

I'm with Ondrej here, I suspect that entry is completely unneeded now. We=
've
gotten pretty good at handling bad INQUIRYs.

So unless you object, I'm going to allow Ondrej's patch, and then I'll fi=
re
up a patch to remove the other version and fire it off to Peter W. to see=
 if
his device works without it.

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Be who you are and say what you feel, because those who mind don't matte=
r
 and those who matter don't mind."
 - Dr. Seuss



--------------enigE69A08CAF5F20AD50FE32287
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkuJbnsACgkQN5XoxaHnMrsHEgCfZe3+4Pz4MNM3UyJOBQZx31gS
fOUAoIANFCE4DTdXfxVr1xWCtycbzCGR
=kYLB
-----END PGP SIGNATURE-----

--------------enigE69A08CAF5F20AD50FE32287--
