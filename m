Return-Path: <linux-kernel-owner+w=401wt.eu-S932090AbXH3L6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbXH3L6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 07:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbXH3L6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 07:58:36 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:33633 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbXH3L6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 07:58:35 -0400
Subject: Re: [PATCH 4/5] Net: ath5k, license is GPLv2
From: Johannes Berg <johannes@sipsolutions.net>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Jiri Slaby <jirislaby@gmail.com>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <1188393226.1131.319.camel@frg-rhel40-em64t-04>
References: <7515194658758617@pripojeni.net>
	 <1188381582.19891.6.camel@johannes.berg>
	 <4af2d03a0708290335x1a9aa38o566e9d416505f280@mail.gmail.com>
	 <1188393226.1131.319.camel@frg-rhel40-em64t-04>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Zf9TLLgNQLJ4S02+oWrc"
Date: Thu, 30 Aug 2007 13:59:42 +0200
Message-Id: <1188475182.2963.15.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Zf9TLLgNQLJ4S02+oWrc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-29 at 15:13 +0200, Xavier Bestel wrote:

> How about asking for changes to be dual-licenced too ?

In theory, that could work, but in practice relying on functions that
the Linux kernel offers in GPLv2-only headers etc. will make the result
GPLv2 anyway, and disentangling it would be a nightmare.

johannes

--=-Zf9TLLgNQLJ4S02+oWrc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1rEu/ETPhpq3jKURAiKOAJ9rw7sEJXX/abTtkYC4KuQg1SV8iQCgj512
JWtOtMI9iI6sDtJc6l5xv3k=
=s6+I
-----END PGP SIGNATURE-----

--=-Zf9TLLgNQLJ4S02+oWrc--

