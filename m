Return-Path: <linux-kernel-owner+w=401wt.eu-S1031083AbXHMNFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031083AbXHMNFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943141AbXHMIQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 04:16:15 -0400
Received: from lug-owl.de ([195.71.106.12]:46106 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968439AbXHMIQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 04:16:03 -0400
Date: Mon, 13 Aug 2007 10:16:00 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [460/2many] MAINTAINERS - SRM (Alpha) environment access
Message-ID: <20070813081559.GL12574@lug-owl.de>
Mail-Followup-To: joe@perches.com, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <46bffbfc.aw6EQE4fWM2Hq6vM%joe@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GU3/x65mZ6MFE8p3"
Content-Disposition: inline
In-Reply-To: <46bffbfc.aw6EQE4fWM2Hq6vM%joe@perches.com>
X-Operating-System: Linux mail 2.6.18-4-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--GU3/x65mZ6MFE8p3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-08-12 23:36:44 -0700, joe@perches.com <joe@perches.com> wrote:
> Add file pattern to MAINTAINER entry
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fa8fb1c..3c134fa 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4386,6 +4386,8 @@ P:	Jan-Benedict Glaw
>  M:	jbglaw@lug-owl.de
>  L:	linux-kernel@vger.kernel.org
>  S:	Maintained
> +F:	arch/alpha/kernel/*srm*
> +F:	arch/alpha/lib/srm*
> =20
>  STARFIRE/DURALAN NETWORK DRIVER
>  P:	Ion Badulescu

NACK.

I only care about arch/alpha/kernel/srm_env.c and don't know about all
the others that match.

So this should simply be:

F:	arch/alpha/kernel/srm_env.c

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:           Ich hatte in letzter Zeit ein bi=C3=9Fchen viel Rea=
litycheck.
the second  :               Langsam m=C3=B6chte ich mal wieder weitertr=C3=
=A4umen k=C3=B6nnen.
                             -- Maximilian Wilhelm (18. Mai 2006, #lug-owl.=
de)

--GU3/x65mZ6MFE8p3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGwBM/Hb1edYOZ4bsRAtekAJ43imuL70J4d031poESZDRYxflSOwCfVtaN
1CJrEVjENLgEvj2IxHDcfVw=
=R5uG
-----END PGP SIGNATURE-----

--GU3/x65mZ6MFE8p3--
