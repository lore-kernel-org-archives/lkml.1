Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbXJ2FeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbXJ2FeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 01:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbXJ2Fdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 01:33:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58100 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbXJ2Fdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 01:33:53 -0400
Date: Mon, 29 Oct 2007 16:33:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] Silence radeon_pm warning
Message-Id: <20071029163343.7fe7e6b8.sfr@canb.auug.org.au>
In-Reply-To: <20071029050202.GA16159@lixom.net>
References: <20071029135911.ba1bfee2.sfr@canb.auug.org.au>
	<20071029050202.GA16159@lixom.net>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Oct_2007_16_33_43_+1100_rlxOXtfMub2z4vVh"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Oct_2007_16_33_43_+1100_rlxOXtfMub2z4vVh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Oct 2007 00:02:02 -0500 Olof Johansson <olof@lixom.net> wrote:
>
> I posted this one a few days ago, without adding a new ifdef (just moving=
 the
> declaration down into the already existing ifdef below it):
>=20
> http://marc.info/?l=3Dlinux-kernel&m=3D119311699109698&w=3D2

Yeah, missed that and yours looks better.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Oct_2007_16_33_43_+1100_rlxOXtfMub2z4vVh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHJXC7TgG2atn1QN8RAorsAJ9qMbbi2lUTNO02IoxFMxQhSNl3kgCdGhFx
QOGcj7EMN+n17WIE43lNN4A=
=hgi+
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Oct_2007_16_33_43_+1100_rlxOXtfMub2z4vVh--
