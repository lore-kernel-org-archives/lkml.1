Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbXGBI4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbXGBI4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 04:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbXGBI4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 04:56:04 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:45533 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbXGBI4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 04:56:02 -0400
Subject: Re: [2.6 patch] drivers/net/wireless/libertas/wext.c: remove dead
	code
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Bunk <bunk@stusta.de>
Cc: Dan Williams <dcbw@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070701202040.GD10869@stusta.de>
References: <20070701202040.GD10869@stusta.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-m7zAeKz37qZGmPRfBjg7"
Date: Mon, 02 Jul 2007 10:53:54 +0200
Message-Id: <1183366434.4089.96.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-m7zAeKz37qZGmPRfBjg7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-07-01 at 22:20 +0200, Adrian Bunk wrote:
> This patch removes dead code introduced by
> commit 90a42210f275e1f828eb6c08bf8252c2d6a774e0 and spotted
> by the Coverity checker.

> --- linux-2.6.22-rc6-mm1/drivers/net/wireless/libertas/wext.c.old	2007-06=
-29 21:52:56.000000000 +0200
> +++ linux-2.6.22-rc6-mm1/drivers/net/wireless/libertas/wext.c	2007-06-29 =
21:53:43.000000000 +0200
> @@ -1823,85 +1823,82 @@ static int wlan_set_encodeext(struct net

out of curiosity, why so much context?

johannes

--=-m7zAeKz37qZGmPRfBjg7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGiL0h/ETPhpq3jKURAn/QAKCKl5F8t/HfdbZ4wZmAHhwNplkIjwCfV3PJ
3AThodhAU7lPkBdjiFT3leA=
=1Swq
-----END PGP SIGNATURE-----

--=-m7zAeKz37qZGmPRfBjg7--

