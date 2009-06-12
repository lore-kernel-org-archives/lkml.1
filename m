Return-Path: <linux-kernel-owner+w=401wt.eu-S1758545AbZFLBMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545AbZFLBMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 21:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbZFLBMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 21:12:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39818 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbZFLBMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 21:12:41 -0400
Date: Fri, 12 Jun 2009 11:12:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steven Whitehouse <swhiteho@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: manual merge of the vfs tree with the gfs2 tree
Message-Id: <20090612111237.0e5972e9.sfr@canb.auug.org.au>
In-Reply-To: <20090527115253.37abd576.sfr@canb.auug.org.au>
References: <20090527115253.37abd576.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Jun_2009_11_12_37_+1000_iGH4fq4g7j7bDwex"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Jun_2009_11_12_37_+1000_iGH4fq4g7j7bDwex
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Wed, 27 May 2009 11:52:53 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the vfs tree got a conflict in
> fs/gfs2/ops_super.c between commit
> 9e6e0a128bca0a151d8d3fbd9459b22fc21cfebb ("GFS2: Merge mount.c and
> ops_super.c into super.c") from the gfs2 tree and commits
> 17af8f24a7750ea3d947904f97eb6dfacf9a88aa ("gfs2: remove ->write_super and
> stop maintaining ->s_dirt") and 8123178eb9ca12cde31a95170746e15a79528a62
> ("push BKL down into ->put_super") from the vfs tree.

This conflict is now against Linus's tree as the gfs2 tree has been
merged.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Jun_2009_11_12_37_+1000_iGH4fq4g7j7bDwex
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoxq4UACgkQjjKRsyhoI8yR1wCfQt2b/ugh8dxNwLjDHdGl88pJ
eOQAn0vnx1YmREGPS/7SH+ab/ItlV1Gn
=I26d
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jun_2009_11_12_37_+1000_iGH4fq4g7j7bDwex--
