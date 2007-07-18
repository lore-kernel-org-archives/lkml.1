Return-Path: <linux-kernel-owner+w=401wt.eu-S1761937AbXGRHlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761937AbXGRHlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbXGRHlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:41:09 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:56341 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330AbXGRHlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:41:08 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH -mm 3/5] Freezer: Prevent new tasks from inheriting TIF_FREEZE set
Date: Wed, 18 Jul 2007 17:41:06 +1000
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>
References: <200707180929.31511.rjw@sisk.pl> <200707180933.32080.rjw@sisk.pl>
In-Reply-To: <200707180933.32080.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3766981.mPNUR4ZiDe";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707181741.06946.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3766981.mPNUR4ZiDe
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Wednesday 18 July 2007 17:33:31 Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>=20
> Tasks should go to the refrigerator only if explicitly requested to do th=
at by
> the freezer and not as a result of inheriting the TIF_FREEZE flag set fro=
m the
> parent.  Make it happen.
>=20
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Nigel Cunningham <nigel@nigel.suspend2.net>

Regards,

Nigel

--nextPart3766981.mPNUR4ZiDe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGncQSN0y+n1M3mo0RAqDxAJwMfbGWUMJS3ssJeiF9uDipEXn/uQCg9i1B
egbOU+4ZtepSCXYbiwUvn78=
=7g3g
-----END PGP SIGNATURE-----

--nextPart3766981.mPNUR4ZiDe--
