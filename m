Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbXCIJCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbXCIJCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 04:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXCIJCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 04:02:25 -0500
Received: from vesl.donpac.ru ([80.254.111.33]:37180 "EHLO vesl.donpac.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbXCIJCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 04:02:23 -0500
Date: Fri, 9 Mar 2007 12:02:19 +0300
To: Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
Message-ID: <20070309090218.GB18056@pazke.donpac.ru>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1173419792.32234.131.camel@localhost.localdomain> <20070309065055.GA18056@pazke.donpac.ru> <20070309075308.GE8798@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
In-Reply-To: <20070309075308.GE8798@infradead.org>
X-Uname: Linux 2.6.18-1-amd64 x86_64
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Andrey Panin <pazke@donpac.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 068, 03 09, 2007 at 07:53:08AM +0000, Christoph Hellwig wrote:
> On Fri, Mar 09, 2007 at 09:50:56AM +0300, Andrey Panin wrote:
> > On 068, 03 09, 2007 at 04:56:32PM +1100, Rusty Russell wrote:
> > > __builtin_types_compatible_p() has been around since gcc 2.95,
> >=20
> > but it's not available in Intel C compiler IIRC :(
>=20
> So what?

Kernel compilation with Intel compiler is (was ?) supported.
This patch will break it.

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFF8SKaIWZCBzwS8mkRAuuDAJ9qj5Gt4dzgm1aiIbPCHyu8bvLXKACfQ/UF
ZQfe5oQgfb433tpKWNn0o+c=
=593z
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
