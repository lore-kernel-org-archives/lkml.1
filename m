Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbYG2BIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbYG2BIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYG2BH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:07:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35186 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbYG2BH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:07:59 -0400
Date: Tue, 29 Jul 2008 11:07:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joerg.roedel@amd.com,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com
Subject: Re: [PATCH] add iommu_num_pages helper function
Message-Id: <20080729110749.728c54e6.sfr@canb.auug.org.au>
In-Reply-To: <20080726134156.GC4401@elte.hu>
References: <20080725134159.GA7493@amd.com>
	<20080725225724J.fujita.tomonori@lab.ntt.co.jp>
	<20080725141425.GB7493@amd.com>
	<20080725233325W.fujita.tomonori@lab.ntt.co.jp>
	<20080726134156.GC4401@elte.hu>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__29_Jul_2008_11_07_49_+1000_2RlbBZKj2b7L.G.f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Jul_2008_11_07_49_+1000_2RlbBZKj2b7L.G.f
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Sat, 26 Jul 2008 15:41:56 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> ok, i'll apply the 3 patches to tip/x86/iommu. As usual, feel free to=20
> send IOMMU cleanups/generalizations/fixes against tip/master:
>=20
>   http://people.redhat.com/mingo/tip.git/README

So, I assume a patch created on July 25 is not destined for 2.6.27,
right?  Especially since it breaks another architecture build and has
only made it to linux-next on July 29 ... and needs more work given the
comments already on this patch.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Jul_2008_11_07_49_+1000_2RlbBZKj2b7L.G.f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiObWUACgkQjjKRsyhoI8w5NwCeNXFE5YlMEVttpHOux9OrLLJL
BHYAn345o6h2x1w2DHq6jtK8BlpJoIsE
=1vi+
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Jul_2008_11_07_49_+1000_2RlbBZKj2b7L.G.f--
