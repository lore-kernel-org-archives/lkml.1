Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbZBFCe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbZBFCe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 21:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758468AbZBFCeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 21:34:44 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55745 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758472AbZBFCen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 21:34:43 -0500
Date: Fri, 6 Feb 2009 13:34:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Wu <cooloney@kernel.org>, dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       vapier.adi@gmail.com
Subject: Re: [PATCH 1/5] Blackfin SPI Driver: use bfin_spi_ prefix on all
 functions
Message-Id: <20090206133436.199d9282.sfr@canb.auug.org.au>
In-Reply-To: <20090205141245.2945141e.akpm@linux-foundation.org>
References: <1233828453-13311-1-git-send-email-cooloney@kernel.org>
	<1233828453-13311-2-git-send-email-cooloney@kernel.org>
	<20090205141245.2945141e.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Feb_2009_13_34_36_+1100_rZTiWukMNBdTrftt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Feb_2009_13_34_36_+1100_rZTiWukMNBdTrftt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 5 Feb 2009 14:12:45 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> As usual, the driver core guys have gone trompling all over other people'=
s code
> and your patch doesn't apply to linux-next.
>=20
> 11 out of 61 hunks FAILED -- saving rejects to file drivers/spi/spi_bfin5=
xx.c.rej

To be fair, next-20090206 has one patch to that file it is a single hunk
and only affects 2 lines and the patch was cc'd to the spi folks (I can't
easily tell when as the driver-core stuff (being a quilt tree) gets
rebased often).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Feb_2009_13_34_36_+1100_rZTiWukMNBdTrftt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmLobwACgkQjjKRsyhoI8xamwCfcM69c1gbjcLP45NDeSbHkaB/
r8AAnR9SsDd6OnlxHOMGxF/DhLXfh2GO
=QCn8
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Feb_2009_13_34_36_+1100_rZTiWukMNBdTrftt--
