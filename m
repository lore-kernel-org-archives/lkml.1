Return-Path: <linux-kernel-owner+w=401wt.eu-S1761203AbYHEQCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761203AbYHEQCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759095AbYHEQCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:02:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37081 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757753AbYHEQCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:02:32 -0400
Date: Wed, 6 Aug 2008 02:02:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Adrian Bunk <bunk@kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: linux-next: wireless-current tree build failure
Message-Id: <20080806020221.7d2c845b.sfr@canb.auug.org.au>
In-Reply-To: <20080805153757.GB22895@cs181140183.pp.htv.fi>
References: <20080805162152.2b55ae5c.sfr@canb.auug.org.au>
	<20080805153757.GB22895@cs181140183.pp.htv.fi>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Aug_2008_02_02_21_+1000_yGKD/1EIuW5+jT2U"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Aug_2008_02_02_21_+1000_yGKD/1EIuW5+jT2U
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Adrian,

On Tue, 5 Aug 2008 18:37:57 +0300 Adrian Bunk <bunk@kernel.org> wrote:
>
> Alexandros Couloumbis already opened a bug for this issue on mips, which=
=20
> also seems to be affected:
>   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D37014
>=20
> It is a gcc bug, but we'll have to work around it in the ath9k driver.

Thanks for fishing that out Adrian.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__6_Aug_2008_02_02_21_+1000_yGKD/1EIuW5+jT2U
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiYeY0ACgkQjjKRsyhoI8znfwCdFiIJ8RCO8lpVNzsG279fgbJD
Sm0AniG1MNuH+NkZeU5yNnB88CkeGg1f
=i/i2
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Aug_2008_02_02_21_+1000_yGKD/1EIuW5+jT2U--
