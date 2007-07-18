Return-Path: <linux-kernel-owner+w=401wt.eu-S1761262AbXGRHkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761262AbXGRHkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbXGRHkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:40:10 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:60334 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbXGRHkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:40:08 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH -mm 1/5] Freezer: Document relationship with memory shrinking
Date: Wed, 18 Jul 2007 17:40:02 +1000
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>
References: <200707180929.31511.rjw@sisk.pl> <200707180930.45564.rjw@sisk.pl>
In-Reply-To: <200707180930.45564.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6176431.Yz8DZegXY6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707181740.04917.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6176431.Yz8DZegXY6
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Wednesday 18 July 2007 17:30:44 Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>=20
> One important reason to freeze tasks, which is that we don't want them to
> allocate memory after freeing it for the hibernation image, has not been
> documented.  Fix it.
>=20
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Acked-by: Nigel Cunningham <nigel@nigel.suspend2.net>

=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart6176431.Yz8DZegXY6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGncPUN0y+n1M3mo0RAo8zAJ9+6z0aRKCqHx78QdRgomrfligrcACfd1JY
KX9ojquBO56E0fHQdpbMF6o=
=NL+9
-----END PGP SIGNATURE-----

--nextPart6176431.Yz8DZegXY6--
