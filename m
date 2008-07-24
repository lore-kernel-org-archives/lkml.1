Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYGXUXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYGXUXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYGXUXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:23:37 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60375 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbYGXUXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:23:36 -0400
Subject: Re: [RFC: 2.6 patch] clarify the WIRELESS_EXT_SYSFS help text
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Bunk <bunk@kernel.org>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>,
       "John W. Linville" <linville@tuxdriver.com>,
       Jean Tourrilhes <jt@hpl.hp.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080724124225.GD32109@cs181140183.pp.htv.fi>
References: <20080724115805.5466c217@mjolnir.drzeus.cx>
	 <1216899520.13587.49.camel@johannes.berg>
	 <20080724124225.GD32109@cs181140183.pp.htv.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PHeGUzR+bhTTVwC2uIbv"
Date: Thu, 24 Jul 2008 22:21:44 +0200
Message-Id: <1216930904.13587.94.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PHeGUzR+bhTTVwC2uIbv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Sure, since we don't know what the next release will be there's little
point in trying to predict it, this patch is fine with me.

> Current Hal uses the CONFIG_WIRELESS_EXT_SYSFS files, so don't claim=20
> there were no known users and recommend to enable the option.
>=20
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

>=20
> b685f62718b947264657c298e5ee5b2149200f68=20
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index ab015c6..e582432 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -39,4 +39,4 @@ config WIRELESS_EXT_SYSFS
>  	  files in /sys/class/net/*/wireless/. The same information
>  	  is available via the ioctls as well.
> =20
> -	  Say Y if you have programs using it (we don't know of any).
> +	  If unsure, say Y.
>=20

--=-PHeGUzR+bhTTVwC2uIbv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIiORUAAoJEKVg1VMiehFYQvwQAJ8Y8VnaUP4h4v3x304SAdJ3
qbyPaPOCABE8ovadDoGYaOCslPdtY4P/vQ4FRlrmPU3Hu24F/cOB1JLpqDm249re
/Foo2Bxh8nYeXqfqvC0NYpb7CtJyJwRAeN5ExUhfGYCO3THFPgQVTmUnuI/TpJeg
1552sIT31N5qnECR9Dj67V3R4qJJeTYG8y7UMvdu+4zj4xs5idw263BdSrmbFw9W
bz+W51Q6j3qhn2cO+4dn22WWE5IltkcqbVEYcZbjreGYMStdJfG672fdEzKFioaU
QAMKSuVYbkkTDcuO0gBMNvtm23+tC3mpVyAk+e8oYXFbBEqlj4UUXXQlr+jiGPjQ
ZocG9IKtNXYEpwKpSmjr068zhq8sh58G38LROQYyCksu9TNNRLcwThqijDueLeDK
ZlaAWmp2jR0/edE//KFYlxvI45MDONGUQTDdiIbAYC4ql/n0zor4KoCZsCsf2sSn
gP29/965rdfte07dlaGFsnU3tHjW1eofboyIdxhKPeFEnN7/y9bWvQ7Dymjz7Ybn
z2IQB9jiuGb2z7dp1zMW5MD4cY8wRzXpB1eaJGdWYdik+Bevgs+PgR9SWSIb67u5
aYnOXhuhrVJeLs81S1FHw5bx8rIm5YyKHE8TYybdtwLcUXGau4QWo+6SNm6pAtz8
iq0wzFEkZ4bHgVUNtwdk
=J1rb
-----END PGP SIGNATURE-----

--=-PHeGUzR+bhTTVwC2uIbv--

