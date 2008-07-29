Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbYG2Gpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbYG2Gpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYG2Gpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:45:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36701 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbYG2Gpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:45:33 -0400
Date: Tue, 29 Jul 2008 16:45:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, joerg.roedel@amd.com,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
Message-Id: <20080729164523.bfd2d539.sfr@canb.auug.org.au>
In-Reply-To: <20080728.222439.176200666.davem@davemloft.net>
References: <20080729110749.728c54e6.sfr@canb.auug.org.au>
	<20080729104722H.fujita.tomonori@lab.ntt.co.jp>
	<20080729135652.f89042c1.sfr@canb.auug.org.au>
	<20080728.222439.176200666.davem@davemloft.net>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__29_Jul_2008_16_45_23_+1000_a7Xt8ibxpn.b8CVb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Jul_2008_16_45_23_+1000_a7Xt8ibxpn.b8CVb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 28 Jul 2008 22:24:39 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> sparc64: Fix build after addition of iommu_num_pages() helper.

I added this to the end of linux-next for today.  Hopefully we will have
a fix in Linus' tree tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Jul_2008_16_45_23_+1000_a7Xt8ibxpn.b8CVb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiOvIMACgkQjjKRsyhoI8w/zgCfdvD9BKiJ+kEvVYQ1hPrVJflt
2MsAn1Xd2KkdYOvD6xXmteHOsh7Qli3K
=RoIi
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Jul_2008_16_45_23_+1000_a7Xt8ibxpn.b8CVb--
