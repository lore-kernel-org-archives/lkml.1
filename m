Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYHAE2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYHAE2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 00:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYHAE2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 00:28:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45884 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbYHAE2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 00:28:03 -0400
Date: Fri, 1 Aug 2008 14:27:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       joerg.roedel@amd.com, mingo@elte.hu, linuxppc-dev@ozlabs.org,
       davem@davemloft.net, sparclinux@vger.kernel.org
Subject: Re: [PATCH] Revert
 "Merge branch 'x86/iommu' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip into for-linus"
Message-Id: <20080801142754.8a6314fa.sfr@canb.auug.org.au>
In-Reply-To: <20080801085106E.fujita.tomonori@lab.ntt.co.jp>
References: <20080801094323.9601d87b.sfr@canb.auug.org.au>
	<20080801085106E.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__1_Aug_2008_14_27_54_+1000_qszNvBgVVH.GLi2S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Aug_2008_14_27_54_+1000_qszNvBgVVH.GLi2S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 1 Aug 2008 08:51:23 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.=
co.jp> wrote:
>
> Ingo has a patch to fix this problem in the x86 tree:
>=20
> http://marc.info/?l=3Dlinux-kernel&m=3D121754062325903&w=3D2

Then consider this a poke (to the appropriate person) to get something
merged to fix the breakage.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__1_Aug_2008_14_27_54_+1000_qszNvBgVVH.GLi2S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiSkMoACgkQjjKRsyhoI8yagACggFN1tewSUDhrbrS2gXAidcpg
G+kAoK6AyhTIH4M2HSa8kfdfbTps5BPG
=avUC
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Aug_2008_14_27_54_+1000_qszNvBgVVH.GLi2S--
