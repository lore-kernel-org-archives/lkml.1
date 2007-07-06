Return-Path: <linux-kernel-owner+w=401wt.eu-S1762957AbXGFWaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762957AbXGFWaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 18:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757383AbXGFWaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 18:30:13 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:51888 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbXGFWaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 18:30:12 -0400
Subject: Re: [PATCH] slub: don't export static kmem_cache_open
From: Johannes Berg <johannes@sipsolutions.net>
To: Bret Towe <magnade@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <dda83e780707061357p798531cbw29758ccf98df60cc@mail.gmail.com>
References: <1183628260.3818.31.camel@johannes.berg>
	 <Pine.LNX.4.64.0707061028001.30516@schroedinger.engr.sgi.com>
	 <1183743340.3779.11.camel@johannes.berg>
	 <dda83e780707061357p798531cbw29758ccf98df60cc@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Xi8BUpninEAMm51jCqPL"
Date: Sat, 07 Jul 2007 00:31:06 +0200
Message-Id: <1183761066.3779.21.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Xi8BUpninEAMm51jCqPL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-07-06 at 13:57 -0700, Bret Towe wrote:
> On 7/6/07, Johannes Berg <johannes@sipsolutions.net> wrote:

> > Oh good. I actually got build problems from that due to a powerpc64 gcc
> > bug so... :)

> this also looks to solve booting issue on a g4 mac mini also

Huh? That doesn't really make sense, but who knows what else that gcc
problem caused.

johannes

--=-Xi8BUpninEAMm51jCqPL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjsKq/ETPhpq3jKURAthXAJ4pqbb7qQ9EC/lN0abOD/9GGy0kMwCfan7o
RLE7srutqFaoae4VJswAOJs=
=l//J
-----END PGP SIGNATURE-----

--=-Xi8BUpninEAMm51jCqPL--

