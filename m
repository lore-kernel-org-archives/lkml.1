Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbYGWElW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbYGWElW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 00:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYGWElN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 00:41:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59255 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbYGWElM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 00:41:12 -0400
Date: Wed, 23 Jul 2008 14:41:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org,
       Kyle McMartin <kyle@mcmartin.ca>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-parisc@vger.kernel.org, Chris Zankel <chris@zankel.net>
Subject: Re: linux-next: Requirements and process
Message-Id: <20080723144104.ac3a74e4.sfr@canb.auug.org.au>
In-Reply-To: <20080502233519.a988b552.akpm@linux-foundation.org>
References: <20080503154542.18807e59.sfr@canb.auug.org.au>
	<20080502233519.a988b552.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Jul_2008_14_41_04_+1000_WinOkhk5k6GJ0abh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jul_2008_14_41_04_+1000_WinOkhk5k6GJ0abh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 2 May 2008 23:35:19 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> On Sat, 3 May 2008 15:45:42 +1000 Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
>=20
> > The following architectures are not in linux-next (and should be):
> >=20
> > alpha		cris		frv
> > h8300		m32r		m68knommu
> > mips		mn10300		parisc
> > um		v850		xtensa
>=20
> mips, m32r, parisc and xtensa do have git trees.  The rest are mastered as
> discrete patches in -mm.
>=20
> Except for m68knommu, which pops unexpectedly out of the woodwork during
> the merge window.  I've asked that this be altered ;)

So (from the above list) cris, m68knommu and mips have joined the
linux-next fray ...

(cc's some maintainers)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Jul_2008_14_41_04_+1000_WinOkhk5k6GJ0abh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiGtmAACgkQjjKRsyhoI8wyOACbBTwN5V0gylPybMMxU5tHHps7
3O4An0XbMoeQaeGJGIPgQjKZkqC5byEO
=8ZSr
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jul_2008_14_41_04_+1000_WinOkhk5k6GJ0abh--
