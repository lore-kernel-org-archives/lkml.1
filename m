Return-Path: <linux-kernel-owner+w=401wt.eu-S1765739AbZCaXoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765739AbZCaXoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763866AbZCaXoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:44:07 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:35591 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765727AbZCaXoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:44:05 -0400
Subject: Re: [PATCH] Add hvc_console to MAINTAINERS
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       roel.kluin@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090331132944.GB2332@yoda.jdub.homelinux.org>
References: <49BF956B.9030109@gmail.com>
	 <20090330133531.f5d99c09.akpm@linux-foundation.org>
	 <20090330205553.GA19278@yoda.jdub.homelinux.org>
	 <20090330141852.59baaeda.akpm@linux-foundation.org>
	 <20090331132944.GB2332@yoda.jdub.homelinux.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SGW8tY8ZyBVnGt98JSSL"
Date: Wed, 01 Apr 2009 10:44:00 +1100
Message-Id: <1238543040.6522.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SGW8tY8ZyBVnGt98JSSL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-31 at 09:29 -0400, Josh Boyer wrote:
> Add a MAINTAINERS entry for the hypervisor virtual console support
> used on IBM POWER servers.
>=20
> Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> ---
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c5f4e9d..387ad45 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2176,6 +2176,11 @@ W:       http://www.ia64-linux.org/
>  T:     git kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
>  S:     Maintained
> =20
> +IBM HYPERVISOR VIRTUAL CONSOLE
> +P:     Several
> +L:     linuxppc-dev@ozlabs.org
> +S:     Maintained

I don't think it's the "IBM" Hypervisor virtual console driver anymore.
There are backends for Xen, Beat (Toshiba) and virtio.=20

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-SGW8tY8ZyBVnGt98JSSL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknSqsAACgkQdSjSd0sB4dIUfQCeILBfRD7KXJXjdtQzw3AaXuVW
ERQAoKYjXtrTZxl9dCMgNU5BXNlEWfRa
=xOsv
-----END PGP SIGNATURE-----

--=-SGW8tY8ZyBVnGt98JSSL--

