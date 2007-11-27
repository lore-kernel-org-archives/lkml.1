Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbXK0NnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbXK0NnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 08:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbXK0NnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 08:43:08 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:49382 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbXK0NnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 08:43:07 -0500
Subject: Re: time accounting problem (powerpc only?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
In-Reply-To: <20071127050031.GC24243@bakeyournoodle.com>
References: <1195814816.4149.94.camel@johannes.berg>
	 <1196094193.4149.287.camel@johannes.berg>
	 <20071127050031.GC24243@bakeyournoodle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oTNo9IylfyH5KXYpo6Gj"
Date: Tue, 27 Nov 2007 14:42:53 +0100
Message-Id: <1196170973.6058.18.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oTNo9IylfyH5KXYpo6Gj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-11-27 at 16:00 +1100, Tony Breeds wrote:
> On Mon, Nov 26, 2007 at 05:23:13PM +0100, Johannes Berg wrote:
> > Contrary to what I claimed later in the thread, my 64-bit powerpc box
> > (quad-core G5) doesn't suffer from this problem.
> >=20
> > Does anybody have any idea? I don't even know how to debug it further.
>=20
> I'll see if I can grab an appropriate machine tomorrow and have a look at
> it.  I think it's just an accounting bug, which is probably my fault :)

Thanks. Let me know if you need any info.

johannes

--=-oTNo9IylfyH5KXYpo6Gj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0we26Vg1VMiehFYAQJjJw//e2gRTdWu+yTGLpwrXixH6O2zBEE6idrQ
u1nm+7glMlJ1gJa09KJ/CejMUoH7O51lEn2Dw/lRTxJuEihrhvHIlU3nA4v67x0n
afksy/Z40Nh86jg8Qd0s+oTjDRBmp7CNV4gA0AMEINfozlgEqEP9Dj8e5LE8j+lZ
5T4JbWDe7C0+zpsJNwWDCQ28+ds619P1hNhueCslKaFXtRLjDja8R4wzlJHBh802
0xOIXp61fnQRS447WOk3OnZPyTC0JWbUvNMUloDHxTh0ELBL8LShIQhNo/SsHjZp
tKnJqhi2lxgahwRvyHDvypLukP7hWsV3SMRr09lYr8uzw8a5s81Ut/9heLmS8V9K
DosRXlpbOJ5XixGEH4I0GHhn1oM55qebF+1VtCVechDAQ7+Vx27V/4VagUQIQ/nE
UmTULGMZlj/bPX1XRzS2nXncWSWw+N85kff2HZif6pYrMC4q58QReTFll8rQNcF8
TEBHUxRdNkZ32Se3z7hEzdqiqss7PIkTr49o/eI69qzAwi7+P312+RYVQa0Dp8D8
QgKu5CcDSKlCdLRY85WQBO5TSF0BTQxUSmoV7SWGzOXlGIQmj6k9lFzCX/LemnMI
HNOHN4RVOQkBQpwkJNnHMZXHmlJ7bnOvvt5LwgJPeeQ5aFSn4FOpHEES44T4/Wus
XK+hdBXFLts=
=0dtu
-----END PGP SIGNATURE-----

--=-oTNo9IylfyH5KXYpo6Gj--

