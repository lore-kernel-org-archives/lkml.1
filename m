Return-Path: <linux-kernel-owner+w=401wt.eu-S1760966AbYEEUSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbYEEUSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756996AbYEEUSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:18:04 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:37596 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800AbYEEUSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:18:02 -0400
Subject: Re: w35und: some more code removal
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <20080505200927.GA7273@elf.ucw.cz> (sfid-20080505_220757_049517_6BA6B525)
References: <20080505200927.GA7273@elf.ucw.cz>
	 (sfid-20080505_220757_049517_6BA6B525)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-G57HyidBMlK5pzcoyo78"
Date: Mon, 05 May 2008 22:17:11 +0200
Message-Id: <1210018631.4181.29.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-G57HyidBMlK5pzcoyo78
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-05 at 22:09 +0200, Pavel Machek wrote:
> Remove some more unneccessary code
>=20
> ---
> commit 5b251c6315097d5f9ab5d30c43813fe74c1db4e4
> tree 5ca21582f55886d5f0249f7ca139687450024581
> parent e44ccdabb97fa4a6cdc1a95adcad7bcc469d0c16
> author Pavel <pavel@amd.ucw.cz> Mon, 05 May 2008 22:08:51 +0200
> committer Pavel <pavel@amd.ucw.cz> Mon, 05 May 2008 22:08:51 +0200

Let me guess, you're using git-am too? :P

johannes

--=-G57HyidBMlK5pzcoyo78
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB9rRaVg1VMiehFYAQIOIw//WgkQOvfEXlpgfHTE7Xsy4oT67OBTtf1R
lQZRddliNK+bXCnEhAmqzrU3F3TIjLqUei7zD5YH0AHY3qThe5UlquIBTTbEeMI0
yG6mbLed/DerUnSI7RZXWySuaYo5KPEv2yihXvCpKDyuSpE1OZalCOFtX5c/XTcZ
2mLLYByyF9Lt5UwoBwMhs0HbuFsWaV7fJAcvFFxcuzzH5jUPJyGDplfn8+lGN08J
NhYWK6JZotVpZUHo6SpNEPhwqsvK7fIPSRsLu9iiEKo4EW6sEiSt3J6ffm70Auw5
MpB8mlBjavj9XZIRORl58QCL2Nz4SocDMOWURL41nmr89RGdxs0va4D6l/9BNcgQ
e91PxKDKt/z2wlZDVLwXm3lS59pFjxr402yHtxpMAMFiW8l1Z8yBBelwpQ+rtBlc
WHJyIBNcofHiZhOJ8sHcQY2peKHzKGjk+TKEH3uaNoHFFigU4a1G3xZuiwTiK42w
Xa7Uk+xNrNFt2v7NQOeWxjVaUMmSMwTdRb+XX9QCRZu+jdMdE64Z8HZSAWnNw22t
OmLza/b0LmtJ+sEMSTkUxKRMzP7Lv3YCdxkPU49U/92waz0qz5wc5wCqFom935Us
xLRRGJhfAOCpv5Re0ODY1feIj3ZwPzGcNttTG9pCt+JcC0IQHxQkYVamMMXrZi3V
aBYVPdGY4SM=
=4kKq
-----END PGP SIGNATURE-----

--=-G57HyidBMlK5pzcoyo78--

