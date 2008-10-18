Return-Path: <linux-kernel-owner+w=401wt.eu-S1751856AbYJRPnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbYJRPnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 11:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYJRPnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 11:43:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59479 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYJRPnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 11:43:39 -0400
Date: Sun, 19 Oct 2008 02:43:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, tglx@linutronix.de, mingo@elte.hu,
       fujita.tomonori@lab.ntt.co.jp, andreas.herrmann3@amd.com,
       joseph.cihula@intel.com, fenghua.yu@intel.com, jbarnes@virtuousgeek.org,
       tony.luck@intel.com, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [ANNOUNCE] iommu-2.6.git tree
Message-Id: <20081019024328.2cda973e.sfr@canb.auug.org.au>
In-Reply-To: <1224343843.6770.1378.camel@macbook.infradead.org>
References: <1224343843.6770.1378.camel@macbook.infradead.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__19_Oct_2008_02_43_28_+1100_qkchoPE2qmX/NbL2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__19_Oct_2008_02_43_28_+1100_qkchoPE2qmX/NbL2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Sat, 18 Oct 2008 16:30:43 +0100 David Woodhouse <dwmw2@infradead.org> wr=
ote:
>
> As previously threatened, I've created an iommu-2.6.git tree:
> 	git://git.infradead.org/iommu-2.6.git
> 	http://git.infradead.org/iommu-2.6.git
>=20
> Stephen, please could you add this tree to linux-next?

Sure (I assume the "master" branch).  However, I already have a tree in
-next called iommu.  It is one of the tip auto branches (auto-iommu-next)
and is currently empty.  So do I name this one dwmw2-iommu, or has Ingo
finished with the other one?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__19_Oct_2008_02_43_28_+1100_qkchoPE2qmX/NbL2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj6BCAACgkQjjKRsyhoI8w4PgCgite0v30eZHPi6/xg+4DJdwbn
BrwAmwX2M8pFsUOYDr71oFW4rUTfyING
=dpwQ
-----END PGP SIGNATURE-----

--Signature=_Sun__19_Oct_2008_02_43_28_+1100_qkchoPE2qmX/NbL2--
