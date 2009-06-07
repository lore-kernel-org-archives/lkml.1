Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbZFGKYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbZFGKYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZFGKYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:24:15 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:39830 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbZFGKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:24:14 -0400
Subject: Re: [ANN] Atheros 802.11n USB firmware source code released
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, otus-devel@venema.h4ckr.net,
       David Woodhouse <dwmw2@infradead.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1244368455.22643.4.camel@localhost>
References: <43e72e890906051204q22278e4cw6beeae27da50e988@mail.gmail.com>
	 <1244326943.12159.5.camel@localhost>  <1244334102.16810.3.camel@localhost>
	 <1244367815.26071.4.camel@johannes.local>
	 <1244368455.22643.4.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dA85OnZ+aOc51V5Kly+z"
Date: Sun, 07 Jun 2009 12:24:10 +0200
Message-Id: <1244370250.2907.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dA85OnZ+aOc51V5Kly+z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-06-07 at 12:54 +0300, Maxim Levitsky wrote:

> Fine, like I expected, but still, I guess there is some 'loader' in
> eeprom?

Yes.

> If there were a documentation too.
> Isn't it possible to publish it?
>=20
> This firmware contains so many 'magic' registers.

There is some, but it's not public. We can try to document some when we
replace the magic values by constants.

johannes

--=-dA85OnZ+aOc51V5Kly+z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKK5VGAAoJEODzc/N7+Qma/dYP/iUfOkbf6yuFwWLdlATdHqNp
HvP/So597y9PjpzKpYvJQEnQJyiccWeMcJIRkeltJWc8Cel0+6zmiyjZ+LUzN4Nl
qcZi7wm2tXC7tVa1+FRNxpOlX5/fgErkSMOmt5P09+icufXF4SR2aCHp8YAOJcGX
TcibdA0RPQo538bbxJMdj24FKqjS+BFP2nGR72qhTeD91brhvs+aAGUVY4qaUkEg
7qrexLxWYL21sVDkASkENsco27tHqx3xWL9qCoetScSi5OokXFxui8FUIlcXe8ke
U9dkSTR2w5PUnFqRQE0y2SuIhTwCfQ1N4680cF54w0zIVmrJni5G5mIA9BmjxU3C
sesPBrbcsd5ghZmtFmfG7dPQxSiNkcHHOUUXGfkYh27NpuPppSK1uOL4e3j/NbcQ
1OyXrWDR2LWl6WwPV7NNzDAs0a/dh4atja/D/iiv2YU+typZQREQCwjJ/mKwKa9p
2JyZjHwMLsy9SZgPRxNBzi5oZwnnZwSXu8Dj7v+G5myUI8PNdi+BiJ9dHGZQuSC4
XTJbgPrQehaOYWB3PSCgnS+E0n0KQMVVWqLUi3vmnUlP/VdL/ZqhVurv2iqwsKq3
0yxcqbnZ9a57m3T9OIUXxtsUj2vr28i5QzDDi6MlxEw8jGnjD7u4K1OY0o0frgoD
JTYnLHfojEwpUTYpKfyM
=y589
-----END PGP SIGNATURE-----

--=-dA85OnZ+aOc51V5Kly+z--

