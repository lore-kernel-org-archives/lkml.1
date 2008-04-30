Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbYD3Hh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbYD3Hh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbYD3Hhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:37:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44697 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708AbYD3Hht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:37:49 -0400
Date: Wed, 30 Apr 2008 17:37:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for April 30
Message-Id: <20080430173743.ce1c9784.sfr@canb.auug.org.au>
In-Reply-To: <20080430.003447.200525841.davem@davemloft.net>
References: <20080430173104.39897492.sfr@canb.auug.org.au>
	<20080430.003447.200525841.davem@davemloft.net>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__30_Apr_2008_17_37_43_+1000_Jqe6c7ZR7Bt.QmHH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Apr_2008_17_37_43_+1000_Jqe6c7ZR7Bt.QmHH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 30 Apr 2008 00:34:47 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 30 Apr 2008 17:31:04 +1000
>=20
> > Also a build breakage in the v4l/dvb code - but this seems to have
> > been caused by not cleaning my tree before the build.
>=20
> No, I'm seeing allmodconfig builds fail even with a clean tree.  It's
> from the recent v4l/dvb merge and I'm bisecting now.

Thanks, Dave.  But don't you have enough to do? :-)

reverting 149ef72deeba57078216c9fa678baff392295853 makes it build for
me ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_Apr_2008_17_37_43_+1000_Jqe6c7ZR7Bt.QmHH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIGCHLTgG2atn1QN8RArtPAJ0RGRsFSBQnLlO6KutMJp2LYTggyACfRSLj
yJs+zbrVgC2LDaARt/LD4eM=
=MrIH
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Apr_2008_17_37_43_+1000_Jqe6c7ZR7Bt.QmHH--
