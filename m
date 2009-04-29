Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbZD2S4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbZD2S4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760022AbZD2Szv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:55:51 -0400
Received: from ns1.t0.or.at ([62.116.70.34]:55435 "EHLO mail.t0.or.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759593AbZD2Szu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:55:50 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Apr 2009 14:55:49 EDT
MailScanner-NULL-Check: 1241635731.18285@PGrTdHKKl1PgkzH7Ve7+xA
Subject: Re: 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS = corruption
From: Andreas Proschofsky <suka@gentoo.org>
To: Mateusz Kaduk <mateusz.kaduk@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, xorg@freedesktop.org,
       linux-kernel@vger.kernel.org, Alex Bennee <kernel-hacker@bennee.com>
In-Reply-To: <b56f065e0904291118r7f008508s32852ccd1bb0b645@mail.gmail.com>
References: <b2cdc9f30904182327w12a3ec32t90c7c6c34980577b@mail.gmail.com>
	 <20090427234947.394f774f@schatten>
	 <b2cdc9f30904272237h3a815282h7e6b932e1c252d17@mail.gmail.com>
	 <20090428095338.3e7b2062@hobbes>
	 <b2cdc9f30904290049k290a59bfh1265a66735b510e2@mail.gmail.com>
	 <20090429090607.2d351545@hobbes>
	 <b56f065e0904291118r7f008508s32852ccd1bb0b645@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FbN+zNNnGzkXmGp1+euC"
Date: Wed, 29 Apr 2009 20:46:48 +0200
Message-Id: <1241030808.2987.0.camel@g-three>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
X-t0-MailScanner-Information: Please contact the ISP for more information
X-t0-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-t0-MailScanner-SpamCheck: not spam,
	SpamAssassin (nicht zwischen gespeichert, Wertung=-0.612,
	benoetigt 5.4, BAYES_00 -2.60, RCVD_IN_SORBS_DUL 1.99)
X-MailScanner-From: suka@gentoo.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FbN+zNNnGzkXmGp1+euC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This is fixed with Kernel 2.6.30-rc3-git6 for me, so you might try this
one.

bye
Andreas

On Wed, 2009-04-29 at 20:18 +0200, Mateusz Kaduk wrote:
> This is realy old issue now. Which I reported at begining of this
> month but exist much longer.
>=20
> https://bugs.freedesktop.org/show_bug.cgi?id=3D20896
>=20
> Two more people also experience this. This only happens with KMS mode.
> I am using 1.6.1 xorg/mesa master/ xf86-intel master and libdrm 2.4.9
> kernel 2.6.30-rc3-git5.
>=20
> I hope someone can soleve this some day.
> _______________________________________________
> xorg mailing list
> xorg@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/xorg
--=20
Andreas Proschofsky
Gentoo Developer / OpenOffice.org

--=-FbN+zNNnGzkXmGp1+euC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkn4oJgACgkQauoogOee02Mz/ACZAZp98BM7vLkIQJ+8IPvIiS3E
9lcAn3wfkk5L/xl49w3Eb49ygcc8pTNo
=luLX
-----END PGP SIGNATURE-----

--=-FbN+zNNnGzkXmGp1+euC--

