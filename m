Return-Path: <linux-kernel-owner+w=401wt.eu-S1751768AbXBMTVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbXBMTVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbXBMTVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:21:06 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:43763 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbXBMTVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:21:05 -0500
Subject: Re: [PATCH] kernel-doc: include struct short description in title
	output
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>
In-Reply-To: <20070213111042.e10a4234.randy.dunlap@oracle.com>
References: <20070213111042.e10a4234.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pkZwGySVNASjUpWNE19b"
Date: Tue, 13 Feb 2007 20:18:37 +0100
Message-Id: <1171394317.10344.111.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pkZwGySVNASjUpWNE19b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-02-13 at 11:10 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Output of a struct in html mode needs to include the short description
> from the struct name line in the output title line.

Yup, that fixes it for structs. I guess I forgot to mention this earlier
because I didn't notice it until now... the same bug exists for
functions as well.

And apparently I never looked at the output for my description for
pm_set_ops.... maybe (hopefully!) it'll teach me to be more careful next
time.

johannes

--=-pkZwGySVNASjUpWNE19b
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF0g8M/ETPhpq3jKURAlWHAJ4qbnXlpL945eMTIW8dBtClown9PACgmp/K
stZcKLWfPmpAsHUqcyz3OCo=
=e6EW
-----END PGP SIGNATURE-----

--=-pkZwGySVNASjUpWNE19b--

