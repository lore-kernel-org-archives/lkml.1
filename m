Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYKEH1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYKEH1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 02:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbYKEH0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 02:26:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43810 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbYKEH0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 02:26:54 -0500
Date: Wed, 5 Nov 2008 18:26:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       travis@sgi.com, "Vegard Nossum" <vegard.nossum@gmail.com>,
       linux-next@vger.kernel.org
Subject: Re: Git next: Second stage of cpu_alloc patches
Message-Id: <20081105182642.8497301a.sfr@canb.auug.org.au>
In-Reply-To: <20081104195205.fe1bf62b.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0811042053510.31638@quilx.com>
	<20081104195205.fe1bf62b.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__5_Nov_2008_18_26_42_+1100_BWO+Dqj1GfLWqE2s"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Nov_2008_18_26_42_+1100_BWO+Dqj1GfLWqE2s
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Tue, 4 Nov 2008 19:52:05 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> On Tue, 4 Nov 2008 20:56:52 -0600 (CST) Christoph Lameter <cl@linux-found=
ation.org> wrote:
>=20
> > The second stage of the cpu_alloc patchset can be pulled from
> >=20
> > kernel.org/pub/scm/linux/kernel/git/christoph/work.git cpu_alloc_stage2
>=20
> Please send the patches for review.  Always.

And I would like to see a bit of positive feedback from the first set
(given we have boot failures bisected down to this stuff) before we add
more on top.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__5_Nov_2008_18_26_42_+1100_BWO+Dqj1GfLWqE2s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkRSrIACgkQjjKRsyhoI8xuRwCdHfN1ZdNogm1ixVFLmSDSaDBS
FawAoLPem5ouN5nt9cre/oG2cNn9n5nU
=hvVH
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Nov_2008_18_26_42_+1100_BWO+Dqj1GfLWqE2s--
