Return-Path: <linux-kernel-owner+w=401wt.eu-S945397AbXHMMcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945397AbXHMMcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939725AbXHMGym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:54:42 -0400
Received: from ozlabs.org ([203.10.76.45]:49975 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933810AbXHMGyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:54:40 -0400
Subject: Re: [PATCH] [43/2many] MAINTAINERS - AOA (Apple Onboard Audio)
	ALSA DRIVER
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, johannes@sipsolutions.net,
       akpm@linux-foundation.org
In-Reply-To: <46bff8b4.nGsvrO+zx5IWj+A6%joe@perches.com>
References: <46bff8b4.nGsvrO+zx5IWj+A6%joe@perches.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zUvc+fxifubz63AfX3S9"
Date: Mon, 13 Aug 2007 16:54:37 +1000
Message-Id: <1186988077.32127.2.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zUvc+fxifubz63AfX3S9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-08-12 at 23:22 -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e2e88f3..016f342 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -420,6 +420,7 @@ M:	johannes@sipsolutions.net
>  L:	linuxppc-dev@ozlabs.org
>  L:	alsa-devel@alsa-project.org (subscribers-only)
>  S:	Maintained
> +F:	sound/oao/

Should be aoa.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-zUvc+fxifubz63AfX3S9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGwAAtdSjSd0sB4dIRAtBKAJ94YhEUOxFBNTBAyma3UcyCQztmBQCfXTPj
SpFkCCOFuW894gwMhtXyDuc=
=AJkb
-----END PGP SIGNATURE-----

--=-zUvc+fxifubz63AfX3S9--

