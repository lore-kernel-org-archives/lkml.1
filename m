Return-Path: <linux-kernel-owner+w=401wt.eu-S1758492AbYFXKxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492AbYFXKxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYFXKxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:53:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58056 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbYFXKxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:53:08 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] uio-howto.tmpl: use standard copyright/legal markings
Date: Tue, 24 Jun 2008 06:53:06 -0400
User-Agent: KMail/1.9.9
Cc: hjk@linutronix.de, linux-kernel@vger.kernel.org
References: <1214190762-26974-1-git-send-email-vapier@gentoo.org> <20080624002005.defb45d3.akpm@linux-foundation.org>
In-Reply-To: <20080624002005.defb45d3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2319576.DkxpRxteYz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200806240653.07080.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2319576.DkxpRxteYz
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 24 June 2008, Andrew Morton wrote:
> On Sun, 22 Jun 2008 23:12:42 -0400 Mike Frysinger <vapier@gentoo.org> wrote:
> > The Userspace I/O HOWTO document uses straight <sect1> tags and plain
> > text to describe copyright/legal information.  It should instead use the
> > <copyright> and <legalnotice> tags like all other documents in the
> > kernel.
>
> There are conflicting changes in this file in linux-next.

looks like the difference is just year range ... i'll post a new patch
-mike

--nextPart2319576.DkxpRxteYz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJIYNITAAoJEEFjO5/oN/WBtpwQANAD7rdZcwrswJ4BGA7VnnST
9/KucrY3PWIS1ALEi0bLJ/Jv5huqYYfMHPeXy7BZAC/U/D4MwJlSZ5ckP01MWpV7
yxu7OG3UGn09ozmeaqvywtI8DNak959f8+8sm/lx3TYroLks1jcTfOjdLJXwQuqv
VWJpse/06SRhUMA8XfV/4ltNVztlBwO55d7N68ObShV+wIecGSb8B8ByClMJCM4W
qDaaC8nWrmYAfSKKRJtHlbvveFr5kkhipIsOR84YpyQB6UVtNwGXEF7ZNmloWEfY
TYHRiaOZvdC+4/3qyORyL5oIeK45BVQCv8rF6bTwqZO0RXalLPZJs8YeYsZx8C7e
24OSEDvGWESh9GyglsOY3bg8vBE1IjtW0E+0TsAgYoM1AlfGQ/KZSH9k4y3m3BUP
emsK3v2MBuUTy9dVBx3t7xj7COHDARdj7Fb06QF3ef7mv+0Im3OTeCmXRPwuYY7k
fIC53LAeEOu4vwxx5Z5PviJfpbeWgKtiQo0lrqLcHRttlotCZajGG6+Ss5dz89Bc
D4gu73AxgulTbOwcWr3Avzv0qEP57ff08VtTQAzxLOLZ2s/lHbmHibm+y82wvxL2
W1HZYy5pa3fA1BIgRu1RLR+AJqJd6jPTWihcsIXURsaIs9VoO0m4AbAchKANIc9W
pLu8VX5G2eQZ8S2tNSV1
=4j8D
-----END PGP SIGNATURE-----

--nextPart2319576.DkxpRxteYz--
