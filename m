Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbYJVHYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbYJVHYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYJVHYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:24:03 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:46966 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbYJVHYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:24:01 -0400
Subject: Re: Regression in 2.6.27-git from commit 43ac2ca3840f64
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       John Linville <linville@tuxdriver.com>
In-Reply-To: <48FE913D.9060205@lwfinger.net>
References: <48FDFCCA.8040604@lwfinger.net>
	 (sfid-20081021_232731_453910_0675C4D6) <1224624636.28639.15.camel@johannes.berg>
	 <48FE913D.9060205@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2f1BokdPra95i8Oc4Pom"
Date: Wed, 22 Oct 2008 09:23:51 +0200
Message-Id: <1224660231.28639.19.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2f1BokdPra95i8Oc4Pom
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 19:34 -0700, Larry Finger wrote:

> >>                     IE: Unknown: 00066C7766646A66

> The unknown IE's don't show up before this commit.

Oh, ok, but that's just more information shown to userspace, that was
intentional, just iwlist doesn't understand how to parse them, for
example the one I quoted above is the SSID.

johannes

--=-2f1BokdPra95i8Oc4Pom
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/tUEAAoJEKVg1VMiehFY3MgP/0qdeTxS6r+F29mySqt+hMaS
WZAzdS3KVb+u7rUezyz5zyX8sE5LBGuPzMpKVetGuXGUHaca/vJd3wJBYLXEi5ya
cGaanCK7u75MUsj/kl1JEmBALwsBavgqxPnNztW6eP8x153Utfdb2HpO34gNAdRD
/IlOxcM8eZbkgs8nCFJS0gthWEjSnQg3jSLLDFsI/69zQY5RYdYawN23WtuzBeQ7
Dx43FIwUpKg+vgubGYQF6ELOAqL6ZL9i1Q+8qdySU9pUs4UzFHSc+UCCVmconD3p
58FL4FPnLErptAZWE+2Y1ZTPzsxZUaJ9EGMHGEPiiyMF5PbWaYUMxf9yaoU35gvB
TWObHU0URHvkkgr9jD3Q3OqRjQ306Ws0VR1eP/dr7j1YhF1plLOgyszvYe7G9ri+
SBZbjvemrDp6lG3ogIdNNG/5HbrLiK9mBNJzbUgxr6RncnRWX7Su7CeqpEz4aLmq
NN5EUpmRkbAdYQHOoUamcmGOgqfawhyiauAaRj08f0I+NL8WK9fk8o7WjjmSHUbN
FkcEshZuKe5zO1MWlMoXOi0KQaHG820zTQZPRdq/iRnb5cJWFYwHgMMoypXQ+rhl
kvMwEWFInXHmp2l1OFqMMsLlJteVwjPCNvltk6iznwWbPb8dC24bshUHxW2Wv9Bm
dEG5XO2+Hwc2XYrgoizn
=PCLY
-----END PGP SIGNATURE-----

--=-2f1BokdPra95i8Oc4Pom--

