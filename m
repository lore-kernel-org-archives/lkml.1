Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0BIKwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 05:52:44 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:7610 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab0BIKwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 05:52:42 -0500
Date: Tue, 9 Feb 2010 10:52:31 +0000
From: Eric B Munson <ebmunson@us.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] docum/vm: split txt and source files
Message-ID: <20100209105231.GA3781@us.ibm.com>
References: <20100208165638.61d53798.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <20100208165638.61d53798.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 08 Feb 2010, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Documentation/vm/:
> Expose example and tool source files in the Documentation/ directory in
> their own files instead of being buried (almost hidden) in readme/txt fil=
es.
> This should help to prevent bitrot.
>=20
> This will make them more visible/usable to users who may need
> to use them, to developers who may need to test with them, and
> to anyone who would fix/update them if they were more visible.
>=20
> Also, if any of these possibly should not be in the kernel tree at
> all, it will be clearer that they are here and we can discuss if
> they should be removed.
>=20
> Also build the recently-added map_hugetlb.c.
> Make several functions static to prevent linker warnings.
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Eric B Munson <ebmunson@us.ibm.com>

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAktxPm8ACgkQsnv9E83jkzpa0ACg8wOIeTe1ZJO2ds13ld6LA2Gm
D3cAn0amTDstkRMILIEx51y6jV8rjJVu
=3Kew
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
