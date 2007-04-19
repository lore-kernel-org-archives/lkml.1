Return-Path: <linux-kernel-owner+w=401wt.eu-S1766976AbXDST6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766976AbXDST6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766978AbXDST6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:58:46 -0400
Received: from iucha.net ([209.98.146.184]:48426 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766976AbXDST6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:58:46 -0400
Date: Thu, 19 Apr 2007 14:58:45 -0500
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: chuck.lever@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Failure! Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-ID: <20070419195844.GT24044@iucha.net>
References: <20070418123842.GF24044@iucha.net> <1176902131.6796.62.camel@heimdal.trondhjem.org> <20070418134225.GG24044@iucha.net> <1176905506.6796.84.camel@heimdal.trondhjem.org> <20070419015232.GO24044@iucha.net> <1176950713.6422.95.camel@heimdal.trondhjem.org> <462786C9.7090405@oracle.com> <1176995848.6663.1.camel@heimdal.trondhjem.org> <20070419155046.GR24044@iucha.net> <1176998982.6663.10.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pnDjx0H/VpusRTEI"
Content-Disposition: inline
In-Reply-To: <1176998982.6663.10.camel@heimdal.trondhjem.org>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--pnDjx0H/VpusRTEI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 19, 2007 at 12:09:42PM -0400, Trond Myklebust wrote:
> See
>    http://client.linux-nfs.org/Linux-2.6.x/2.6.21-rc7/
>=20
> I'm giving the first 5 patches of that series (i.e.
> linux-2.6.21-001-cleanup_unstable_write.dif to
> linux-2.6.21-005-fix_nfsv4_resend.dif) an extra beating since those are
> the ones that I feel should go into 2.6.21 final in order to fix the
> read/write regressions that have been reported. They should be identical
> to the patches that I posted on lkml in the past 3 days.
>=20
> Please feel free to grab them and give them a test.

The copy completed some time ago, but now I cannot ssh into the box!
This is a new development, as before I was always able to ssh into,
even when the copy slowed down to a trickle.

I'm far from the machine right now, so I will do some more tests
tonight, but right now, the new patchset is not good.  What is the
difference between reverting the patch you sent yesterday and your
current fifth patch?  I assume the other four are identical, right?

Regards,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--pnDjx0H/VpusRTEI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJ8n0ND0rFCN2b1sRAtVGAJ9zHIAljVI2GgaRx7g7O710rQ/unQCffftg
pnCcHgHf/mvU6BRPybGuwpA=
=OxRK
-----END PGP SIGNATURE-----

--pnDjx0H/VpusRTEI--
