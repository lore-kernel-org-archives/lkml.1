Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbZHRHRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbZHRHRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 03:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZHRHRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 03:17:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55221 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbZHRHRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 03:17:09 -0400
Date: Tue, 18 Aug 2009 17:17:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felix Blyakher <felixb@sgi.com>
Cc: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eric Sandeen <sandeen@sandeen.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: manual merge of the xfs tree with Linus' tree
Message-Id: <20090818171702.3faea920.sfr@canb.auug.org.au>
In-Reply-To: <523385BE-5397-49A3-A158-FD1B9D12F067@sgi.com>
References: <20090818101215.aba4d0bf.sfr@canb.auug.org.au>
	<523385BE-5397-49A3-A158-FD1B9D12F067@sgi.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__18_Aug_2009_17_17_02_+1000_T2xiKNXEzHC1HcEm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Aug_2009_17_17_02_+1000_T2xiKNXEzHC1HcEm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felix,

On Tue, 18 Aug 2009 01:49:52 -0500 Felix Blyakher <felixb@sgi.com> wrote:
>
> Thanks for the fix, but there is no need to carrying it separately
> from the xfs master tree. I merged the bc990f5 commit back into the
> the master tree, and fixed all conflicts (there was another one in
> fs/xfs/xfs_iget.c). I planned to do it anyway for 2.6.32.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__18_Aug_2009_17_17_02_+1000_T2xiKNXEzHC1HcEm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqKVW4ACgkQjjKRsyhoI8wp5QCffu5AQbebon4gmSqHHCqsCHeH
VIgAoJHvVyt1EmlWe2hQd+pr6GBDlshS
=DL1X
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Aug_2009_17_17_02_+1000_T2xiKNXEzHC1HcEm--
