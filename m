Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab0BTKxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 05:53:38 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:42731 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab0BTKxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 05:53:37 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
	 <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
	 <1266518735.3829.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com>
	 <1266656213.5347.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-K1JkwR3pb0kpO2SY+s3S"
Date: Sat, 20 Feb 2010 11:53:26 +0100
Message-ID: <1266663206.5347.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-K1JkwR3pb0kpO2SY+s3S
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-02-20 at 17:06 +0800, Am=C3=A9rico Wang wrote:

> >> Does my following untested patch help?
> >
> > Sorry, no. I'll hook up a screen to the box after I return from the
> > fresh market.

> Are you sure there is no difference? :-/

No ... could be a different deadlock now :) Not sure how likely that is
though.

> Also, could you please also apply the 4 patches from Eric?
>=20
> You can get them here:
> http://lkml.org/lkml/2010/2/11/334

Will do.

johannes

--=-K1JkwR3pb0kpO2SY+s3S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLf78iAAoJEODzc/N7+QmaNhcQALHKhm9Y4d+sIatrhwE7Zo3w
0z2r4ohe51snqb2IbqQiVCo315YTK6jzRGnIPosR2Q2a2NNAyxqFMZXx+IYiwJPj
/zJ56V2D1W7nO+39St2uswBud7mgiEwdTggfAaVenHq+ORDlK86FyJ+MTF2SrYLB
V8WMsCjSfVmaQkrbgEHaoYsVrDq1aiOShEWHlzT1yTiKta6+M7F2ovi4CJjtkuSo
vtXPT3Z5c/pR4wIq2fTHoUjvmDPAPtR3rLs/Py6at9AT25+gNhG0bNGFZ+7XwK6f
rYYccHLbfrdDYlO4VjCeLR1b225D8Zlkht+db2yW+tyMBY2HumnP2JXM4/rtNwP1
vZjBsAXUDVtmIyb/LNlvwRtu5I9lU7HCVedosBWCOjKcwypPtVofzBvfb32x1y6M
mpTywTWUTcCp+5AsnhwoENQJtdToOJ1zu2BmjSFTNirWkTVu1FhQRfZSsGx5Odii
GG5tdotthbmwXZHxCYYZQiz8jjhBHdBRWart5+IlsCEPwP3P48WodLQBz/071MIp
2xnNeTOESDul5Jr0M9ShwgP4z9RWWX2CQJva3fc6IrsF3dV0JFyzvSg+GwUEeCuv
Vegspm1QIPFL/A2B7+aPRv3GrVs60YTC8li/8J8BuybZ9qF543EkQ25kD8zqkulE
RlOPchTBDx9Y83xF5ioo
=cFan
-----END PGP SIGNATURE-----

--=-K1JkwR3pb0kpO2SY+s3S--

