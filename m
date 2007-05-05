Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbXEEQN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbXEEQN0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbXEEQN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:13:26 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:53067 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbXEEQNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:13:25 -0400
Subject: Re: [PATCH -mm] PM: Separate hibernation code from suspend code
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <200705051421.31067.rjw@sisk.pl>
References: <200705041132.32227.rjw@sisk.pl>
	 <20070504233135.4671cd98.akpm@linux-foundation.org>
	 <200705051216.39780.rjw@sisk.pl>  <200705051421.31067.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+6z9x+nJYMKy2kQJKFvh"
Date: Sat, 05 May 2007 14:27:08 +0200
Message-Id: <1178368028.7408.93.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+6z9x+nJYMKy2kQJKFvh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-05-05 at 14:21 +0200, Rafael J. Wysocki wrote:
>=20
> Power off the system instead of halting it if the 'platform' mode of
> hibernation
> has been requested, but hibernation_ops is not set.=20

Ehm, unless you made a mistake in the patch then that shouldn't be
possible.

johannes

--=-+6z9x+nJYMKy2kQJKFvh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGPHgc/ETPhpq3jKURAm5lAJ9V5s8ecKNe+DmNPhzK0ZyGdrHLIgCfQUlh
uhnf7TVcyevX+oNsUnZ2Z5E=
=xmRt
-----END PGP SIGNATURE-----

--=-+6z9x+nJYMKy2kQJKFvh--

