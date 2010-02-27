Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030827Ab0B0Udg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 15:33:36 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:34888
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030814Ab0B0Udf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 15:33:35 -0500
Date: Sat, 27 Feb 2010 12:33:17 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Phil Dibowitz <phil@ipom.com>
Cc: Ondrej Zary <linux@rainbow-software.org>,
       usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [usb-storage] [PATCH] [resend] unusual_devs.h: Fix capacity for SL11R-IDE 2.6c
Message-ID: <20100227203317.GM20232@one-eyed-alien.net>
Mail-Followup-To: Phil Dibowitz <phil@ipom.com>,
	Ondrej Zary <linux@rainbow-software.org>,
	usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <201002241141.10103.linux@rainbow-software.org> <20100224192959.GJ20232@one-eyed-alien.net> <201002242222.21008.linux@rainbow-software.org> <20100224224739.GK20232@one-eyed-alien.net> <4B896E79.6090302@ipom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7IgncvKP0CVPV/ZZ"
Content-Disposition: inline
In-Reply-To: <4B896E79.6090302@ipom.com>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2010 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Sat, 27 Feb 2010 12:33:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7IgncvKP0CVPV/ZZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 27, 2010 at 08:11:53PM +0100, Phil Dibowitz wrote:
> On 02/24/2010 11:47 PM, Matthew Dharm wrote:
> > Phil D. --
> >=20
> > I recommend circling around with pwaechtler@loewe-komp.de to see if we
> > can't condense these into a single entry.
>=20
> I'm with Ondrej here, I suspect that entry is completely unneeded now. We=
've
> gotten pretty good at handling bad INQUIRYs.
>=20
> So unless you object, I'm going to allow Ondrej's patch, and then I'll fi=
re
> up a patch to remove the other version and fire it off to Peter W. to see=
 if
> his device works without it.

Seems like a reasonable plan.

Matt


--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

S:  Another stupid question?
G:  There's no such thing as a stupid question, only stupid people.
					-- Stef and Greg
User Friendly, 7/15/1998

--7IgncvKP0CVPV/ZZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFLiYGNHL9iwnUZqnkRAl6oAJ9jgjVp17JQH0yatUPIqjyb7oJixQCbBQqs
WLfgUpoemTdoJo0CCOdh+y0=
=vB7l
-----END PGP SIGNATURE-----

--7IgncvKP0CVPV/ZZ--
