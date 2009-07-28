Return-Path: <linux-kernel-owner+w=401wt.eu-S1751150AbZG1ETN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbZG1ETN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 00:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbZG1ETM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 00:19:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52531 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbZG1ETM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 00:19:12 -0400
Date: Tue, 28 Jul 2009 14:19:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: drbd tree build failure
Message-Id: <20090728141907.0d9fb648.sfr@canb.auug.org.au>
In-Reply-To: <200907271707.58733.philipp.reisner@linbit.com>
References: <20090727173754.6a04e781.sfr@canb.auug.org.au>
	<200907271109.33271.philipp.reisner@linbit.com>
	<a4423d670907270438n3e8f07caoa45124b1bd7b2386@mail.gmail.com>
	<200907271707.58733.philipp.reisner@linbit.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Jul_2009_14_19_07_+1000_5=Q93C5E.CiE/6NJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Jul_2009_14_19_07_+1000_5=Q93C5E.CiE/6NJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Philipp,

On Mon, 27 Jul 2009 17:07:58 +0200 Philipp Reisner <philipp.reisner@linbit.=
com> wrote:
>
> On Monday 27 July 2009 13:38:44 Alexander Beregalov wrote:
> > One more issue
> >
> > drivers/block/drbd/drbd_main.c: In function 'drbd_buildtag':
> > drivers/block/drbd/drbd_main.c:3738: error: dereferencing pointer to
> > incomplete type
>=20
> Ohh, right. I have never tried to build a kernel with the DRBD patch
> without CONFIG_MODULES set.
>=20
> It is fixed now.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__28_Jul_2009_14_19_07_+1000_5=Q93C5E.CiE/6NJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpufDsACgkQjjKRsyhoI8zDsQCfQ59nbVSWYbPV1dugVWYQNxxY
80UAni/UXlytZMQPI5UYWVo8+6Ec0xkN
=ifz6
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Jul_2009_14_19_07_+1000_5=Q93C5E.CiE/6NJ--
