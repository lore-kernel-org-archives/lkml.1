Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbXFKWm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbXFKWm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 18:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbXFKWmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 18:42:49 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:35566 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbXFKWmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 18:42:49 -0400
Subject: Re: beeping patch for debugging acpi sleep
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Christian Leber <christian@leber.de>,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20070611120034.f6d972de.akpm@linux-foundation.org>
References: <20070518213701.GA810@core> <20070520200142.GB5235@ucw.cz>
	 <20070602182014.GB29546@core> <20070609130817.GI27793@elf.ucw.cz>
	 <20070611120034.f6d972de.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0JOppPrNeO4BCBqcgoMP"
Date: Tue, 12 Jun 2007 08:42:51 +1000
Message-Id: <1181601771.5064.2.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0JOppPrNeO4BCBqcgoMP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

Wouldn't it be much more useful if it was unconditionally compiled in
and controlled instead by a sysfs entry? That way it will be far more
useful to $user who doesn't know or want to know how to compile and
install a kernel, but wants to do what they can to get provide helpful
debugging info and perhaps even get it going.

Yes, Pavel, I'll supply a patch if you (plural) agree.

Regards,

Nigel

--=-0JOppPrNeO4BCBqcgoMP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGbc/rN0y+n1M3mo0RAuRbAKDaBJjYUAdqBhXt+MoLwwD2nH4MOACg80UY
xTetNQhtycB7PQ7XSmGaWKc=
=a+Tj
-----END PGP SIGNATURE-----

--=-0JOppPrNeO4BCBqcgoMP--

