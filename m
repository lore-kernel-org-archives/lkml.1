Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbZETBmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbZETBmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 21:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbZETBmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 21:42:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32947 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369AbZETBmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 21:42:17 -0400
Date: Wed, 20 May 2009 11:42:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Karsten Keil" <keil@b1-systems.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/19] mISDN update for linux-next
Message-Id: <20090520114209.9aa67e28.sfr@canb.auug.org.au>
In-Reply-To: <caec140cd2930ac1e0c3fa7df8beee1a.squirrel@bilbo.ozlabs.org>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
	<caec140cd2930ac1e0c3fa7df8beee1a.squirrel@bilbo.ozlabs.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_May_2009_11_42_09_+1000_MPdWYu4NQl3g70kQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_May_2009_11_42_09_+1000_MPdWYu4NQl3g70kQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Karsten,

On Wed, 20 May 2009 08:22:11 +1000 (EST) "Stephen Rothwell" <sfr@canb.auug.=
org.au> wrote:
>
> Karsten Keil wrote:
> > This is a update of the mISDN driver for linux-next.
> > It syncs the mISDN driver with the development on git.misdn.org.
> > More updates (new hardware support) will follow.
> >
> > You can pull it from
> > git://master.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6-next.git
> > master
>=20
> Should I take this as a request to add that tree to the linux-next tree?

Actually, I have now looked at that tree and it is based on linux-next
(of yesterday).  I cannot incorporate such a tree into linux-next (since
linux-next effectively rebases every day and such a tree would drag in
old versions of other trees).  All the trees in linux-next must be based
on other trees that do not rebase - usually Linus' tree, but the net tree
is also a possibility.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_May_2009_11_42_09_+1000_MPdWYu4NQl3g70kQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoTX/EACgkQjjKRsyhoI8wTfgCgvBCAyUHSXWA9S5x+1WO0GG1o
1WEAn1iAA3nv5X8zyjH7p5QVAzuRQX/d
=fUsQ
-----END PGP SIGNATURE-----

--Signature=_Wed__20_May_2009_11_42_09_+1000_MPdWYu4NQl3g70kQ--
