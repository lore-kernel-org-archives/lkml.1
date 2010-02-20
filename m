Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab0BTKwr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 05:52:47 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:42721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab0BTKwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 05:52:46 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <2375c9f91002200130v1af400a3qe6045b484a25299@mail.gmail.com>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200130v1af400a3qe6045b484a25299@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jTn8uQFRgnWXTVPGWZOl"
Date: Sat, 20 Feb 2010 11:52:36 +0100
Message-ID: <1266663156.5347.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jTn8uQFRgnWXTVPGWZOl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-02-20 at 17:30 +0800, Am=C3=A9rico Wang wrote:

> Hey, johannes
>=20
> Not sure if you made some mistake here, the one you report here [1]
> is _not_ the same with this one reported by Benjamin.
>=20
> Please make sure what you are talking about here is the same one.
>=20
> Thanks.
>=20
> 1. http://lkml.org/lkml/2010/2/18/33

I'm talking about the problem Ben reported -- that one is completely
different. Was your patch supposed to address _that_ one?

johannes


--=-jTn8uQFRgnWXTVPGWZOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLf77wAAoJEODzc/N7+QmaC7oP/2Wjdhn7IG8MNdPJ74x9twED
awKufyak0U9rXj/lLIE3SsxQSYGlnR5u3MswhXkT7O4y9Ui0/dDqxKI2sQma6DmK
QUe2doFZ+qvsj0otW4mFmSVNrga5rCV/VfMHD1x0PFqbJwSGbllEVtvZBEc0TBYO
yc5qrMTST/fVYIQVY+LGBTCmn1ZXiBnYbQ1tVbZz1aG16kZ8y4YA2Mluic4IWpkH
HwhtG0gVJXaZI+XZneTHxdNxiEFX3+5hgGA2bx9CVCHCg5o39sKHvZL6brfNcohE
5q0tL1oyXFmLfZaQhU3tJ4DONoF/pkI2boEfauLJuWQScH16OBPJT6tRLKAw+sdP
b3BIUmeUOejL67mbaFScEJ7AyLjTiFO2rccupGkrZf2/DVLozR59qF1NmhOm3BxB
4udRl8DSKo0QJKBXB9x+C4NFkhx2+AURvx8ne2YesDJwJouOwfdOmL41CnPBQ1rH
kj62qr1H/UdJ1jyaQd/D59T73AcgakDHGPgYRbKYY/S4g12YfWFko6dN4rxUt66U
7MPDvzFzn+nhTQDj8B+1ElEC1SlXW8IJgQGUhwE7LvG8gjHGtwB0++Sm4vePjEvT
Ipq91yORfGxhctUO0+RxkyZyAJzOURNtzjoDxFJC1wG+/oavvCR+TNgPMqIPav9k
Tl+2RHaSqvcCWx1r0/UI
=0Xu9
-----END PGP SIGNATURE-----

--=-jTn8uQFRgnWXTVPGWZOl--

