Return-Path: <linux-kernel-owner+w=401wt.eu-S1031255AbXDUOnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031255AbXDUOnz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 10:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031257AbXDUOnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 10:43:55 -0400
Received: from iucha.net ([209.98.146.184]:49793 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031255AbXDUOny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 10:43:54 -0400
Date: Sat, 21 Apr 2007 09:43:53 -0500
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Chuck Lever <chuck.lever@oracle.com>, linux-kernel@vger.kernel.org,
       nfs@lists.sourceforge.net
Subject: Re: [PATCH 0/5] 2.6.21-rc7 NFS writes: fix a series of issues
Message-ID: <20070421144352.GG24044@iucha.net>
References: <20070420200358.7897.75870.stgit@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mMdCh5/a0q2ATNCM"
Content-Disposition: inline
In-Reply-To: <20070420200358.7897.75870.stgit@heimdal.trondhjem.org>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--mMdCh5/a0q2ATNCM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 20, 2007 at 04:03:58PM -0400, Trond Myklebust wrote:
> I've split the issues introduced by the 2.6.21-rcX write code up into 4
> subproblems.
[snip]
> My thanks to the various patient victim^Wpeople who helped with extensive
> testing.

I've pulled the tree this morning
(0f851021c0f91e5073fa89f26b5ac68e23df8e11) and ran big-copy from a
gnome session.  All is well.

Thanks,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--mMdCh5/a0q2ATNCM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGKiMoND0rFCN2b1sRAtyxAKCVphzC1CY6sGXtfBdoEwI4TqAFzQCgldMV
RyFdyLkarOMMJAPaJ0vtl0s=
=eUrA
-----END PGP SIGNATURE-----

--mMdCh5/a0q2ATNCM--
