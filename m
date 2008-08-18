Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbYHROFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbYHROFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbYHROF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:05:28 -0400
Received: from gateway.crfreenet.org ([81.92.146.254]:45970 "EHLO
	mail.crfreenet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbYHROF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:05:26 -0400
Date: Mon, 18 Aug 2008 16:05:20 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [DRIVERS/VIDEO] removed unused #include <version.h>
Message-ID: <20080818140520.GA30027@localhost.localdomain>
References: <20080817073553.1636.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20080817073553.1636.WEIYI.HUANG@gmail.com>
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 17, 2008 at 07:51:26AM +0800, Huang Weiyi wrote:
> The driver(s) below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
>   drivers/video/arkfb.c
>   drivers/video/s3fb.c
>   drivers/video/vt8623fb.c
>=20
> This patch removes the said #include <version.h>.
>=20
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

Acked-by: Ondrej Zajicek <santiago@crfreenet.org>


--=20
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEARECAAYFAkipgZ8ACgkQw1GB2RHercNq7gCfdKn44gIkK90Drm9GBDUr1WFz
ZyAAn34gzkUcYIAZQlS8WqdgkTB542Wf
=y7mU
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
