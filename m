Return-Path: <linux-kernel-owner+w=401wt.eu-S1764263AbXGFRer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764263AbXGFRer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762127AbXGFRej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:34:39 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:36589 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762149AbXGFRei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:34:38 -0400
Subject: Re: [PATCH] slub: don't export static kmem_cache_open
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707061028001.30516@schroedinger.engr.sgi.com>
References: <1183628260.3818.31.camel@johannes.berg>
	 <Pine.LNX.4.64.0707061028001.30516@schroedinger.engr.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VzuwuisoHkA9zmxVuOda"
Date: Fri, 06 Jul 2007 19:35:40 +0200
Message-Id: <1183743340.3779.11.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VzuwuisoHkA9zmxVuOda
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-07-06 at 10:29 -0700, Christoph Lameter wrote:
> On Thu, 5 Jul 2007, Johannes Berg wrote:
>=20
> > kmem_cache_open is static so shouldn't be exported.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> I already fixed that. Patch is in Andrew's tree.

Oh good. I actually got build problems from that due to a powerpc64 gcc
bug so... :)

johannes

--=-VzuwuisoHkA9zmxVuOda
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjn1s/ETPhpq3jKURAo16AKC00Jio0RCFEIwjG1SSlP8x783aAgCgu1cS
AerhoqJ3zX3ZcaDu1iSqlss=
=xn8a
-----END PGP SIGNATURE-----

--=-VzuwuisoHkA9zmxVuOda--

