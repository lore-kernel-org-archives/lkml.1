Return-Path: <linux-kernel-owner+w=401wt.eu-S1030727AbXDRIql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030727AbXDRIql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 04:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030682AbXDRIqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 04:46:40 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:45081 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030649AbXDRIqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 04:46:25 -0400
Message-ID: <4625DAFC.4000208@drzeus.cx>
Date: Wed, 18 Apr 2007 10:46:52 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_hera.drzeus.cx-20448-1176885983-0001-2"
To: Madhusudhan c <cr.madhusudhan@gmail.com>
CC: linux-kernel@vger.kernel.org, philipl@overt.org
Subject: Re: MMCv4 support (8-bit support missing)
References: <ff1613620704162359w62df9e0ao6c43215a767bd706@mail.gmail.com>
In-Reply-To: <ff1613620704162359w62df9e0ao6c43215a767bd706@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-20448-1176885983-0001-2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Madhusudhan c wrote:
> Hi Pierre/philip,
>=20

Hi Madhusudhan,

Feel free to add me as cc in the future if you want me to notice your mai=
l ;)

> This is regarding the MMCv4 support that came in as part of the MMC
> core of 2.6.20 linux kernel version.
>=20
> The high speed MMC cards can support 4-bit/8-bit transfers. The 8-bit
> support seems to be missing from the MMCv4 support implemented by
> Philip Langdale .

As soon as hardware with specs is available we'll start hacking. :)

> To support 8-bit transfers the core needs to implement "bus testing
> procedure". This requires support for CMD19 and CMD14.
>=20
> Why is the support for bus testing procedure msiing from the MMCv4 supp=
ort?
>=20

We haven't determined it as necessary, and as Philip commented, most (if =
not
all) controllers cannot properly support the test.

Rgds
Pierre


--=_hera.drzeus.cx-20448-1176885983-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGJdr/7b8eESbyJLgRAm5AAJ9Tu+gMzHKl31PLsx2RGkdnNyzdeACgmtvh
OaRwQrC1BTGh3ipppSrlXho=
=YvTj
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-20448-1176885983-0001-2--
