Return-Path: <linux-kernel-owner+w=401wt.eu-S1759902AbXGEIvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902AbXGEIvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbXGEIvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:51:09 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:38270 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199AbXGEIvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:51:08 -0400
Subject: Re: [PATCH] debug workqueue flushing deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Sattler <tsattler@gmx.de>
In-Reply-To: <20070705084806.GB3476@elte.hu>
References: <1183577668.9662.11.camel@johannes.berg>
	 <20070705084806.GB3476@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WjEXzkh0dFMV/tNipZs4"
Date: Thu, 05 Jul 2007 10:52:04 +0200
Message-Id: <1183625525.3818.9.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WjEXzkh0dFMV/tNipZs4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-07-05 at 10:48 +0200, Ingo Molnar wrote:

> btw., small patch format comment: it would be useful (in the future) to=20
> send such combined patches as:
>=20
>  [patch 0/2] general description
>  [patch 1/2] first patch
>  [patch 2/2] second patch

Sure, no problem. I usually do that automatically due to quilt but this
was just 2 out of 52 patches I have pending right now so... :) And akpm
says that 0/2 should only contain stuff not meant for the changelog.

johannes

--=-WjEXzkh0dFMV/tNipZs4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjLE0/ETPhpq3jKURAlAyAKCcDv4bW9HWcdhnoHlfkhklc1dIygCggKuD
q62DRO/UudHWDP+CNRI6OrE=
=6TKD
-----END PGP SIGNATURE-----

--=-WjEXzkh0dFMV/tNipZs4--

