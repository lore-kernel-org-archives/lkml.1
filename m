Return-Path: <linux-kernel-owner+w=401wt.eu-S948257AbXHMQX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S948257AbXHMQX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S948055AbXHMPKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:10:00 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:39644 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S948026AbXHMPJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:09:57 -0400
Message-ID: <46C0742E.1050009@freedesktop.org>
Date: Mon, 13 Aug 2007 08:09:34 -0700
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: joe@perches.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [404/2many] MAINTAINERS - RCUTORTURE MODULE
References: <46bffb88.0TXKye2kVNUPvAc5%joe@perches.com>
In-Reply-To: <46bffb88.0TXKye2kVNUPvAc5%joe@perches.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig99374FC8907B43F53D68814B"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig99374FC8907B43F53D68814B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5377742..0e0e351 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3854,6 +3854,7 @@ P:	Josh Triplett
>  M:	josh@freedesktop.org
>  L:	linux-kernel@vger.kernel.org
>  S:	Maintained
> +F:	kernel/rcutorture.c

Also:
+F: Documentation/RCU/torture.txt

- Josh Triplett



--------------enig99374FC8907B43F53D68814B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGwHQ8GJuZRtD+evsRAtCtAJwPlOaeEIi0gamDsbaVjxFKLJHyXgCgi4OW
HkRzv8nOAxeizrJqIz9BTr8=
=geyC
-----END PGP SIGNATURE-----

--------------enig99374FC8907B43F53D68814B--
