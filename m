Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbYBVHVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbYBVHVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 02:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYBVHVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 02:21:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35263 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbYBVHVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 02:21:23 -0500
Date: Fri, 22 Feb 2008 18:21:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: Tree for Feb 22
Message-Id: <20080222182116.b809022f.sfr@canb.auug.org.au>
In-Reply-To: <20080222170421.9e17d143.sfr@canb.auug.org.au>
References: <20080222170421.9e17d143.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_Feb_2008_18_21_16_+1100_4K8UqL1ojSohIlAz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Feb_2008_18_21_16_+1100_4K8UqL1ojSohIlAz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Feb 2008 17:04:21 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Status of my local build tests is at
> http://kisskb.ellerman.id.au/kisskb/branch/9/.  The sparc builds have
> been mostly disabled while I obtain a working cross compiler.

I have reenabled the sparc and sparc64 builds but there is a bug in 32bit
sparc (in Linus' tree) at the moment.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__22_Feb_2008_18_21_16_+1100_4K8UqL1ojSohIlAz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHvnfxTgG2atn1QN8RAsUSAJ9lpu5ASQxsn5ZQoEAbgSO/pagUJgCeLnEg
wj78FYHGlMZZnK2eOfjGccY=
=RPpl
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Feb_2008_18_21_16_+1100_4K8UqL1ojSohIlAz--
