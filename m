Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbYGBV44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbYGBV44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYGBV4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:56:45 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:35963 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbYGBV4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:56:45 -0400
Subject: Re: b43 locks the machine when resuming after suspend to disk
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Giacomo Mulas <gmulas@ca.astro.it>, linux-kernel@vger.kernel.org,
       debian-kernel@lists.debian.org,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <1215035167.13270.8.camel@johannes.berg>
References: <alpine.DEB.1.10.0807021830300.32045@capitanata.ca.astro.it>
	 <200807022340.31894.rjw@sisk.pl>  <1215035167.13270.8.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-d6ncXvM5dU+Vqv2gAoSP"
Date: Wed, 02 Jul 2008 23:56:01 +0200
Message-Id: <1215035761.13270.10.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-d6ncXvM5dU+Vqv2gAoSP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > I think you need the appended patch, but it only applies to linux-next.
>=20
> A different version has been merged into what will become 2.6.26. I'll
> see what we can do about stable.

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
itdiff;h=3Def3a62d272f033989e83eb1f26505f93f93e3e69;hp=3D6d1a3fb567a728d314=
74636e167c324702a0c38b

Anybody have a stable tree around to see if that applies? I think it
should.

johannes

--=-d6ncXvM5dU+Vqv2gAoSP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIa/luAAoJEKVg1VMiehFYK1kQAJ9Sn36pXglZe5YI1IoNB8d6
Z+0kCrYmXIfzP0Ubp3d8lX6Xh7aUQHvEAMvkbit6wM1uw6pEFqrQFqpCaZpYj/Fs
iydrYMLgMGNu0S4XyuCxJLV9AJ5lA9ewSiFxIEFU0cmCHODz5dHfw/LTIGqyrxlT
HxEQ0nSr4l2fSxhMp8VJQ0FlfyrKZWOfwalqqSt3qC3TbFBDqZCK8iTj/DZXyISX
pjMupmLapjs9YkWAIWHI6Dq0ZM1tb8qAD+21nPV3AScwjqpuCxPuFFH1ltnk8QIS
qgVYY0rZ4iBhGCdMhWk8MVkQBQ4zlyAGnFmZPLTbT2GGIuxgHtaZFMKG+n+QFsWG
tbESfiIRYpkVnLFoFcyGr7ChFoXVfxLbPntZsL+L0pZEsucVSj6+SnJDSy0sEpCM
OZaY0kITBdlVK+nOoxyS7RkrXaQ2w1umvCeaiZZFYBCsvtEjkgXpwPxvFCCYN+Vg
WcTULYy//R8QQGOUfEiPnhpGkJEofE5R/63f1e9qzFfph+B00JzlpIcS7cc+5YeV
s/WiAYLuijHlka2CfIkuFO6BQmGl/Ix7raWMI333J2Y6ONz6ROJIJu2kXeCBrwaD
A6BcT4oswqjvjakY6uL5Cbn9iNEqHpUCs9yYoKBKh1uzpx1eSkud9WB3QXisUwNQ
qr3WPJmxlmctrvKTTUJj
=c4XD
-----END PGP SIGNATURE-----

--=-d6ncXvM5dU+Vqv2gAoSP--

