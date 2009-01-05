Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZAELkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZAELkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbZAELkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:40:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42168 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbZAELkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:40:20 -0500
Date: Mon, 5 Jan 2009 22:40:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>
Subject: Re: 2.6.29 -mm merge plans
Message-Id: <20090105224007.20e60d02.sfr@canb.auug.org.au>
In-Reply-To: <20090105004300.19ed52d1.akpm@linux-foundation.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__5_Jan_2009_22_40_07_+1100_YEnk6_JWRDz+cS61"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Jan_2009_22_40_07_+1100_YEnk6_JWRDz+cS61
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 5 Jan 2009 00:43:00 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> powerpc-change-u64-s64-to-a-long-long-integer-type.patch

I am working on this starting from this (Ingo's) patch.  I'll feed stuff
through the powerpc tree.

> m68knommu-use-the-new-byteorder-headers.patch
> m68knommu-set-no_dma.patch
>=20
>   Architecture things.  Will merge.

I have an m68nommu tree as part of linux-next should these go there?
(though the last - still outstanding - commit was in November).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__5_Jan_2009_22_40_07_+1100_YEnk6_JWRDz+cS61
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklh8ZcACgkQjjKRsyhoI8wiWACgpBQaX9DYo4ENmwYxKxVwU6Hi
WiAAniIkzniyIjYjfWyuU/zG2OeKWVTm
=F4aI
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Jan_2009_22_40_07_+1100_YEnk6_JWRDz+cS61--
