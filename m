Return-Path: <linux-kernel-owner+w=401wt.eu-S1030585AbXAaVP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030585AbXAaVP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 16:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030584AbXAaVP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 16:15:28 -0500
Received: from mx.laposte.net ([81.255.54.11]:14681 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030582AbXAaVP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 16:15:27 -0500
Subject: Re: Free Linux Driver Development!
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070131201258.GB15128@kroah.com>
References: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org>
	 <20070131201258.GB15128@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AqXPGp7VbNoz8odH3LxF"
Organization: Adresse perso
Date: Wed, 31 Jan 2007 22:15:20 +0100
Message-Id: <1170278120.21878.48.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.5 (2.9.5-2.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AqXPGp7VbNoz8odH3LxF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le mercredi 31 janvier 2007 =C3=A0 12:12 -0800, Greg KH a =C3=A9crit :
> On Wed, Jan 31, 2007 at 02:06:32PM +0100, Nicolas Mailhot wrote:

[Reordering for the sake of argument]

> > There are many out-of-tree drivers (ivtv, lirc, various webcam=20
> > drivers,
> > enhanced USB keyboard handlers...) with merging not planified or taking
> > ages.
>=20
> See my above comment about lirc.  As for the others, everyone knows
> where we are at, and what the critera is for getting their code into the
> tree, so it's not like we are hiding anywhere :)

The perception of many out-of-tree projects is "if I try to get in-tree
I'll be submitted to vicious review, and I'll have to fix the code my
myself, and that's assuming someone bothers to review it at all". What
you've just wrote is no different:

> we will gladly take any
> currently out-of-the-tree drivers into mainline, as long as they follow
> our rules and coding style issues, please do so.

In other words, getting an out-of-tree driver in is a major unrewarding
work commitment for its author (especially considering that if he was
familiar with good kernel coding, chances are he'd have worked in-tree
from the start, with an experimental driver)

Contrast it with "give us a partial NDAed spec and we'll write a driver
from scratch for you".

You're asking way more of people that have a lot less resources than
hardware manufacturers. Many of those projects did try to get in-tree at
least once before giving up.

> > I'd really love if the same offer was extended to GPL out-of-tree drive=
r
> > trees.
>=20
> This kind of offer has _always_ been there for out-of-tree GPL drivers.
> I have contacted many different groups and driver authors over the years
> to offer my help in trying to get their code into the mainline kernel.
>=20
> Some take me up on the offer, others ignore it, and still others activly
> refuse to do so, saying they want to stay out-of-the tree (lirc is one
> of these examples...)

And when resources were scarce respecting this kind of decision was the
right thing. But if there are enough resources for your offer, I
question letting whole classes of drivers we have documentation for (in
the form of code) out-of-tree (even if that means some less-than-amiable
forking).

Both the OLPC and the N800 have toy (webcam) video capabilities. The
logical next spec (next hardware generation) is stronger video with
remoting (someone will probably sell remote add-ons before).

Are they going to lack in-tree support just because the reference
framework is out-of-tree, and we respect its authors' wishes so much
nothing can happen till they change their mind ?

(And that's assuming they're dead-set on being out-of-tree. Like I wrote
before they're not getting the same deal you're offering to hardware
manufacturers)

Meanwhile you're asking for specs of hardware no Linux user has, because
no form of Linux support ever existed. This is a strange use of
resources.

Regards,

--=20
Nicolas Mailhot

--=-AqXPGp7VbNoz8odH3LxF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEABECAAYFAkXBBugACgkQI2bVKDsp8g1ZIQCgiPdE9ekny7TRy/AMM5rGVVd0
ymAAoONbYmoz0hAcpg3jKH9rK/mOqXrV
=U3aH
-----END PGP SIGNATURE-----

--=-AqXPGp7VbNoz8odH3LxF--
