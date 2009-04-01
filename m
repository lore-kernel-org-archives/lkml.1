Return-Path: <linux-kernel-owner+w=401wt.eu-S1764108AbZDAAE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764108AbZDAAE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757634AbZDAAER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:04:17 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55012 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638AbZDAAEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:04:16 -0400
Subject: Re: [PATCH] Add hvc_console to MAINTAINERS
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       roel.kluin@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090331235057.GB563@zod.rchland.ibm.com>
References: <49BF956B.9030109@gmail.com>
	 <20090330133531.f5d99c09.akpm@linux-foundation.org>
	 <20090330205553.GA19278@yoda.jdub.homelinux.org>
	 <20090330141852.59baaeda.akpm@linux-foundation.org>
	 <20090331132944.GB2332@yoda.jdub.homelinux.org>
	 <1238543040.6522.10.camel@localhost>
	 <20090331235057.GB563@zod.rchland.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Py/Iofe4NS3COC9azBJA"
Date: Wed, 01 Apr 2009 11:04:13 +1100
Message-Id: <1238544253.6522.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Py/Iofe4NS3COC9azBJA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-31 at 19:50 -0400, Josh Boyer wrote:
> On Wed, Apr 01, 2009 at 10:44:00AM +1100, Michael Ellerman wrote:
> >On Tue, 2009-03-31 at 09:29 -0400, Josh Boyer wrote:
> >> Add a MAINTAINERS entry for the hypervisor virtual console support
> >> used on IBM POWER servers.
> >>=20
> >> Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> >> ---
> >>=20
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index c5f4e9d..387ad45 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -2176,6 +2176,11 @@ W:       http://www.ia64-linux.org/
> >>  T:     git kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
> >>  S:     Maintained
> >> =20
> >> +IBM HYPERVISOR VIRTUAL CONSOLE
> >> +P:     Several
> >> +L:     linuxppc-dev@ozlabs.org
> >> +S:     Maintained
> >
> >I don't think it's the "IBM" Hypervisor virtual console driver anymore.
> >There are backends for Xen, Beat (Toshiba) and virtio.=20
>=20
> Was just going by the copyright in the files, and Documentation/powerpc/h=
vc*
>=20
> Also, if there are other backends, then is the list specified really
> correct?  Perhaps it should just be linux-kernel.

I would say /also/ linux-kernel.

I think there's still more folks on linux-ppc who have looked at the
driver than elsewhere, but cross-posting to lkml is probably good as
well.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-Py/Iofe4NS3COC9azBJA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknSr30ACgkQdSjSd0sB4dKBjgCgjKzOWeLmAGOFSqJWgYsWTpm6
W7sAnirTqnTOESjZHD0kRh1MeUo77jZq
=F8X4
-----END PGP SIGNATURE-----

--=-Py/Iofe4NS3COC9azBJA--

