Return-Path: <linux-kernel-owner+w=401wt.eu-S1764573AbXGFSES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764573AbXGFSES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 14:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762971AbXGFSEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 14:04:08 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:57164 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762480AbXGFSEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 14:04:06 -0400
Subject: Re: [PATCH] slub: don't export static kmem_cache_open
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0707061054571.30575@schroedinger.engr.sgi.com>
References: <1183628260.3818.31.camel@johannes.berg>
	 <Pine.LNX.4.64.0707061028001.30516@schroedinger.engr.sgi.com>
	 <1183743340.3779.11.camel@johannes.berg>
	 <Pine.LNX.4.64.0707061054571.30575@schroedinger.engr.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-E8161OIHujlQNi508Lw7"
Date: Fri, 06 Jul 2007 20:05:08 +0200
Message-Id: <1183745108.3779.19.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-E8161OIHujlQNi508Lw7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-07-06 at 10:55 -0700, Christoph Lameter wrote:
> On Fri, 6 Jul 2007, Johannes Berg wrote:
>=20
> > > I already fixed that. Patch is in Andrew's tree.
> >=20
> > Oh good. I actually got build problems from that due to a powerpc64 gcc
> > bug so... :)
>=20
> Well in that case we may have to push the patch into 2.6.22 or stable.

Dunno. I had three such errors and have sent patches for all of them,
DaveM just accepted one, Paulus hasn't said anything yet and this was
the third. Olaf said the GCC PR is http://gcc.gnu.org/PR31490 and it
seems to fit.

johannes

--=-E8161OIHujlQNi508Lw7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjoRS/ETPhpq3jKURAlxQAKCI1T5FuarBUVKbpEN6S3V9jPEB4QCdFrqI
30lR+cUhHNrbG++n4lybgMU=
=E4aV
-----END PGP SIGNATURE-----

--=-E8161OIHujlQNi508Lw7--

