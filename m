Return-Path: <linux-kernel-owner+w=401wt.eu-S1760934AbXKHOnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760934AbXKHOnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 09:43:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756693AbXKHOmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 09:42:54 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:44661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbXKHOmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 09:42:54 -0500
Subject: Re: [PATCH (2.6.25) 0/2] suspend/hibernate Kconfig cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200711072317.48023.rjw@sisk.pl>
References: <20071107135758.100171000@sipsolutions.net>
	 <200711072317.48023.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LPCf6j2vx5LlscfbT5zp"
Date: Thu, 08 Nov 2007 15:44:13 +0100
Message-Id: <1194533053.6294.42.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LPCf6j2vx5LlscfbT5zp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Since they touch a couple of architectures, I think it's better to merge =
them
> through -mm.

Ok. Andrew, do you want them now or wait until .24 settles down more?

johannes

--=-LPCf6j2vx5LlscfbT5zp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzMgvKVg1VMiehFYAQKgPA/+Iaa4nHI7amYle6KYasUesMWv/KrXu7YR
Qemvujly6ESTF76sXrMKRKEvtE2/JznozQah7fZ1e2sP50g0MpluxUAWRIdz5Hfc
HrGgpWInShFbqlRyJJ5JKiZEbnNWy0V29rvZxS22zdyx+Kfz1AFA+vJAUh2yx47d
IJCO9v3Gqv+XBMIbwkFVzYwRsmRU8Ww/rukvyHb9Gy/eAYQDnr09Ph1w9eSV1l7Q
/sJHeB68RbLXwboIL1w1D/95n0VxgTOQEzpYAq6nUCYECoIzybZ+cr9B6DPVsOkk
0sZreWt3SHLi5qtu9jf92yTWMC6KX15I+MwesbJldtzr+tKnB7cF+HBbVp2Bg9Fh
GenoXgLM5Mvnxxihs8Ii7ft5c7N2/KnO3ytScqkMA9XM1XEo8opdttGOJYqERJmr
8IVOk5tp3GPUGoKCEC1m0clyOsjcFKA7bUADeTbQNEeGdObZvyBEHHnvoXFjYlzJ
bt4F5JfYlhjBXbUNBI/IatwmmsTuOre34QdBOcHkMKOpeQtvhIxMHCf7VGXak1CX
dPUoAxYMpnEmXtXLmXG9LHbop95KULtt4s7Zr/zEQDyfXXE7rDncfzqXaKI3LQ7M
ZLNYDtvlA2HORjr5RPIOBa5BunO4e3MUvM7NkYOTX1KEArti+bzd18u2at8WFFNx
p2IpBVIDoWA=
=R6Mx
-----END PGP SIGNATURE-----

--=-LPCf6j2vx5LlscfbT5zp--

