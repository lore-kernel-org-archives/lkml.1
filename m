Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbXH0LJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbXH0LJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 07:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXH0LIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 07:08:53 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:43434 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbXH0LIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 07:08:53 -0400
Subject: Re: [linux-pm] Re: [PATCH -mm 2/2] Hibernation: Arbitrary boot
	kernel support on x86_64
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel@smtp2.linux-foundation.org, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200708271306.46778.rjw@sisk.pl>
References: <200708241206.57178.rjw@sisk.pl>
	 <20070824162346.ec57f508.akpm@linux-foundation.org>
	 <1188069225.9529.23.camel@johannes.berg>  <200708271306.46778.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-a8szxdRAbelrfnnUkXO7"
Date: Mon, 27 Aug 2007 13:09:47 +0200
Message-Id: <1188212987.7837.5.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-a8szxdRAbelrfnnUkXO7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-27 at 13:06 +0200, Rafael J. Wysocki wrote:

> Well, I don't like the "weak symbols" stuff, but I have managed to limit =
the
> number of additional #ifdefs in snapshot.c to just one.
>=20
> The "generic" patch is now the following:

Fine with me, I was just throwing out ideas anyway :)

johannes

--=-a8szxdRAbelrfnnUkXO7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG0rD7/ETPhpq3jKURAkH5AJoD/5QoDWUKD+z+Zbxtmt+Y/0UwcACdGORZ
Xdlc9B58E0uQZ2076XKXmM8=
=Sl+6
-----END PGP SIGNATURE-----

--=-a8szxdRAbelrfnnUkXO7--

