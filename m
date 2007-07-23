Return-Path: <linux-kernel-owner+w=401wt.eu-S933028AbXGWVwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028AbXGWVwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbXGWVwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:52:06 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:52423 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbXGWVwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:52:05 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC] [PATCH 0/5] Dynamically allocated pageflags.
Date: Tue, 24 Jul 2007 07:52:04 +1000
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200707232305.12364.nigel@nigel.suspend2.net> <1185200995.2714.58.camel@laptopd505.fenrus.org>
In-Reply-To: <1185200995.2714.58.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4162455.S2hmh5UmmA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707240752.04726.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4162455.S2hmh5UmmA
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Tuesday 24 July 2007 00:29:55 Arjan van de Ven wrote:
> On Mon, 2007-07-23 at 23:05 +1000, Nigel Cunningham wrote:
> > Hi all.
> >=20
> > As we all know, pageflags have been a scarce resource for a while now.=
=20
These=20
> > patches seek to help address that issue by adding support for a new typ=
e=20
> > of 'dynamically allocated' pageflag.
>=20
>=20
> but... does this really solve it? I mean.. you can still run out... so
> then what?

Well, the intention is that you can use this implementation instead for fla=
gs=20
where the performance hit doesn't matter [so much].

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart4162455.S2hmh5UmmA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGpSMEN0y+n1M3mo0RAkxmAKDS96NbrcVcLmvng+Zl5NhwMHbArwCgkuEM
hDBeDtLZpfUGMNapXYCcrdg=
=AuAd
-----END PGP SIGNATURE-----

--nextPart4162455.S2hmh5UmmA--
