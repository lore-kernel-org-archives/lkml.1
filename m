Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbYAPLzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbYAPLzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 06:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYAPLy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 06:54:58 -0500
Received: from mail.phnxsoft.com ([195.227.45.4]:2285 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbYAPLy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 06:54:57 -0500
Message-ID: <478DF073.2020300@imap.cc>
Date: Wed, 16 Jan 2008 12:54:27 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: where to maintain userspace daemon for line discipline
References: <45AE507E.3040601@imap.cc> <20070122115644.b538908f.akpm@osdl.org> <45CA4D32.6010302@zytor.com>
In-Reply-To: <45CA4D32.6010302@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4CB1F8F3FE959B5D05F07739"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4CB1F8F3FE959B5D05F07739
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

H. Peter Anvin schrieb:
> Andrew Morton wrote:
>>>
>>> Is there an appropriate place in or near the kernel tree for
>>> stuff like that?
>>=20
>> Nope.  The requirement arises regularly.
>>=20
>> util-linux would seem to be a suitable place, but apparently there
>> are, umm, isues surrounding that.
>=20
> util-linux-ng is already going, so it's a good place.

I have asked on the util-linux-ng mailing list but received
a flat refusal by Karel:

>  I don't think that util-linux-ng is there for this purpose. It's not
>  place for HW specific tools. Sorry.

Back to square one.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig4CB1F8F3FE959B5D05F07739
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHjfB8Q3+did9BuFsRAp8zAJ9jBvEn9ftphfOlJQs7UH4s7aLdvACggsFa
8csK4Op98ETihI8j0xL2lRI=
=zIJl
-----END PGP SIGNATURE-----

--------------enig4CB1F8F3FE959B5D05F07739--
