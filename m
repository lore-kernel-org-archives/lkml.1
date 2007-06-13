Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbXFMBRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbXFMBRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 21:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbXFMBRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 21:17:43 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:53274 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbXFMBRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 21:17:42 -0400
Subject: Re: beeping patch for debugging acpi sleep
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Christian Leber <christian@leber.de>,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <200706121411.56016.rjw@sisk.pl>
References: <20070518213701.GA810@core>
	 <20070611120034.f6d972de.akpm@linux-foundation.org>
	 <1181601771.5064.2.camel@nigel.suspend2.net>
	 <200706121411.56016.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3oYyC4yF43QGs2VzvXo4"
Date: Wed, 13 Jun 2007 11:17:39 +1000
Message-Id: <1181697460.4910.7.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3oYyC4yF43QGs2VzvXo4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Tue, 2007-06-12 at 14:11 +0200, Rafael J. Wysocki wrote:
> Hi,
>=20
> On Tuesday, 12 June 2007 00:42, Nigel Cunningham wrote:
> > Hi.
> >=20
> > Wouldn't it be much more useful if it was unconditionally compiled in
> > and controlled instead by a sysfs entry? That way it will be far more
> > useful to $user who doesn't know or want to know how to compile and
> > install a kernel, but wants to do what they can to get provide helpful
> > debugging info and perhaps even get it going.
>=20
> I like this idea.
>=20
> > Yes, Pavel, I'll supply a patch if you (plural) agree.
>=20
> I agree.  :-)

Ok. I'll take Pavel's silence as agreement too. I'll be a little slow
(as usual, nowadays!), but will try to get it done next week. I think I
can in clear conscience do it on Redhat time if I don't manage it
beforehand.

Regards,

Nigel

--=-3oYyC4yF43QGs2VzvXo4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGb0WzN0y+n1M3mo0RAviBAKDcyGwi47tquQEljKq7NJl9VadOJQCdGVRj
Sq3DFI6+C+/w4+2BUND96Vk=
=+Cux
-----END PGP SIGNATURE-----

--=-3oYyC4yF43QGs2VzvXo4--

