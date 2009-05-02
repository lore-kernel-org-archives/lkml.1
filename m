Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZEBQo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZEBQo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 12:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbZEBQos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 12:44:48 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:35194 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbZEBQos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 12:44:48 -0400
Subject: Re: Probe Timeouts with 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
From: Johannes Berg <johannes@sipsolutions.net>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, niel.lambrechts@gmail.com
In-Reply-To: <f7848160905020420t114db70dq4018bab2ab53fc8f@mail.gmail.com>
References: <f7848160904301838q4883106fq8d31e2e7c0b10a14@mail.gmail.com>
	 <1241165805.13562.2.camel@johannes.local>
	 <f7848160905011328o68010ba0rf8e18fa7ce88c7b5@mail.gmail.com>
	 <1241252825.13562.20.camel@johannes.local>
	 <f7848160905020420t114db70dq4018bab2ab53fc8f@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oxxwDFddLuB2z/hLFBxT"
Date: Sat, 02 May 2009 18:44:42 +0200
Message-Id: <1241282682.13562.21.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oxxwDFddLuB2z/hLFBxT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-02 at 07:20 -0400, Parag Warudkar wrote:

> > Can you make sure the txpower is set correctly, on your compat? Just sa=
y
> > "iwconfig wlan0" or whatever _while_ associated -- and check that it
> > reports 15dBm or so.
>=20
> It shows 27 dBm when associated - both for mainline and compat.

Good.

> Still get the disassociated messages.

Right, different problem then. Can you put that into a kernel.org
bugzilla please?

johannes

--=-oxxwDFddLuB2z/hLFBxT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/Hh3AAoJEKVg1VMiehFYTKEQAI9KYywB4WU5Trlvw7K0RMM/
IpNoox6A2zMVcU+i7cjRDlrnCB4yQXOsC/hB5Z3GClX0ury8gj06pHJf6bAhRG7B
Ggrkr5LzB8MUqIHeukek7b0VrkqszIxdvOCHQ/YVk24WTT7+ZCu73rjl5HrGbqQe
2K1j+zXi2K0NucIKSzv7RYrklyyp9xdCOKiR6w/8jfsTrykI/1zD/TRy/Mw240Mp
nKomZKM8vzsN9RbqN643s6PP5O6CpsvXtsSl6AvIiqopnybD4iJ2GoMZIFfUy6Of
dURf7k4KoLrskKEBtQl4YjDelVKZeghsNyszFp9X6Xpm957QO/ux3tiz0MudCprh
4oiUJluePPFiSIjyXY96QvosnzL3ZOzeZ8Ix00dKjIj+YRo9jBLyd7d9Rbv7zQfs
wAbApA9+0jykX+dmrYWZKDyTrs+rLDEO6auAN2PY6n/iarnLrzWhNKxCLogDphvH
S3LZm3+T7jJCmS6YstLoBXhfdHtHgJ5j8gZtZTdpeWziSL/+m2Pce42Kv7LR9XFZ
9bbhgvYumPOKa6ptbQVYZYzndQQk9oE74jDUy1RWyVGIvOfEc/lU9EQW8dl/QHH6
92xZ/CJmU9d7Cln0dz9QjjqO7X3IV3UY/ujateD3mkWUOLaHRsXm08X3nM2lZlCw
Zsa45y6O9loga23onwmj
=zNMd
-----END PGP SIGNATURE-----

--=-oxxwDFddLuB2z/hLFBxT--

