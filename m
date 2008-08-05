Return-Path: <linux-kernel-owner+w=401wt.eu-S1761372AbYHEQHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761372AbYHEQHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYHEQGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:06:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41913 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbYHEQGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:06:54 -0400
Date: Wed, 6 Aug 2008 02:06:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Adrian Bunk <bunk@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: v4l/mips build problem
Message-Id: <20080806020647.2cf11a2b.sfr@canb.auug.org.au>
In-Reply-To: <20080805154122.GC22895@cs181140183.pp.htv.fi>
References: <20080806012357.55625daf.sfr@canb.auug.org.au>
	<20080805154122.GC22895@cs181140183.pp.htv.fi>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Aug_2008_02_06_47_+1000_hXNUOzlXW0oxCw40"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Aug_2008_02_06_47_+1000_hXNUOzlXW0oxCw40
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Aug 2008 18:41:22 +0300 Adrian Bunk <bunk@kernel.org> wrote:
>
> On Wed, Aug 06, 2008 at 01:23:57AM +1000, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > Linus' current tree gets the following error during a mips allmodconfig
> > build:
> >=20
> > drivers/media/video/vino.c:4364: error: implicit declaration of functio=
n `video_usercopy'
>=20
> Andrew fixed it with drivers-media-video-vinoc-needs-v4l2-ioctlh.patch=20
> in -mm.

Maybe we should send that one Linusward ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__6_Aug_2008_02_06_47_+1000_hXNUOzlXW0oxCw40
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiYepcACgkQjjKRsyhoI8wMRgCggFHLNyfoQrKrKjpkSIGfIEcX
F1oAoIERan3FacdwFgwxh5JPDSswWwkm
=olAO
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Aug_2008_02_06_47_+1000_hXNUOzlXW0oxCw40--
