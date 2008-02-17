Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbYBQFdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbYBQFdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 00:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYBQFde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 00:33:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38203 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbYBQFdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 00:33:32 -0500
Date: Sun, 17 Feb 2008 16:33:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: "Bryan Wu" <cooloney.lkml@gmail.com>, linux-next@vger.kernel.org,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: first tree
Message-Id: <20080217163326.c20ffb21.sfr@canb.auug.org.au>
In-Reply-To: <200802162123.47355.rgetz@blackfin.uclinux.org>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
	<386072610802150033k4dc2faf1je119bf5516336ee9@mail.gmail.com>
	<20080217023337.e94ceb48.sfr@canb.auug.org.au>
	<200802162123.47355.rgetz@blackfin.uclinux.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__17_Feb_2008_16_33_26_+1100_tSQaT8kh0zV48uJo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__17_Feb_2008_16_33_26_+1100_tSQaT8kh0zV48uJo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Robin,

On Sat, 16 Feb 2008 21:23:47 -0500 Robin Getz <rgetz@blackfin.uclinux.org> =
wrote:
>
> You can grab (i386 rpms and tar ball) that should work from:
>=20
> http://blackfin.uclinux.org/gf/project/toolchain/frs/?action=3DFrsRelease=
View&release_id=3D375
>=20
> You will need:
>  - toolchain blackfin-toolchain-08r1-8.i386.rpm
>  - c library (either one of):
>     - blackfin-toolchain-uclibc-default-08r1-8.i386.rpm
>     - blackfin-toolchain-uclibc-full-08r1-8.i386.rpm
>=20
> Other arch's & packages should appear shortly.

Thanks, I will have a look.  My current build machines are powerpc, so I
may have to wait ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__17_Feb_2008_16_33_26_+1100_tSQaT8kh0zV48uJo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHt8crTgG2atn1QN8RAmeMAJ0ZVeVWBSbYvh9Vzccljp/5pjxHNgCdHt4T
1utphbPta+lRJtNvCoKOyms=
=5djK
-----END PGP SIGNATURE-----

--Signature=_Sun__17_Feb_2008_16_33_26_+1100_tSQaT8kh0zV48uJo--
