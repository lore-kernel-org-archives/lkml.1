Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbZLaNTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbZLaNTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 08:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZLaNTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 08:19:41 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:37548 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbZLaNTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 08:19:41 -0500
Subject: Re: linux-next: wireless tree build warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091231105709.c50f22c0.sfr@canb.auug.org.au>
References: <20091231105709.c50f22c0.sfr@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ks4JRklZRwiwCSbyzAiQ"
Date: Thu, 31 Dec 2009 14:19:25 +0100
Message-ID: <1262265565.3592.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ks4JRklZRwiwCSbyzAiQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-12-31 at 10:57 +1100, Stephen Rothwell wrote:
> Hi John,
>=20
> Today's linux-next build (i386 defconfig) produced thes warnings:

Yeah I didn't notice because it was 64-bit here, Kalle already send a
fix.

johannes

--=-ks4JRklZRwiwCSbyzAiQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLPKTaAAoJEODzc/N7+QmapHUP/RfKfBbiH/LVVh+3ccOMXNvq
nLllpGF41j4hmn4Se1F+8miiMsiRR+ulDlbvyhPcnoB14+aEu7ZzggXLs7v8UiF8
WKHN3x65U9ZWhWpjLpy/I91eVD27QcQZDBP8U9DeqSnHmAdwV/puhMDlz9vwmMSd
1K6O3j69U8zAIInN2Aa5MmU7tVvqgPZoBLCj1Q8Ztdw2kPZR77WgtmqkDooDOqr6
xoubFWltZ9wbTj5JdjIHfBtu0zd3bJid3WAQJ4KzLG2vmrflxJXA65HR4PwmPcu0
7gsKuC+quK4shgEUrUei01J/8r7l94SHBPQUkTI7j7QqJ/CBI3kkZiYjY7eFoXwW
34cO2HWuggiVXXhgB4Lb370tJfXJ4KHtBqaR7SlsD4bA7cmEwlFSvRLQnjzYX7gn
R5tE5J6nqiuAUKdng6KeYFP2PFcorEfMqKV0aPmoOiJYK6plapD+Ud501vUU6IPg
2cy1NSq8X+AbcZnK0pTw9+FEdZEpSbvsZGNqML3KomaMyEcn9MRRxAQzA5tvKf5Y
Im5LWVPhZH0Yn/ONQxV6hiPuBR9dgJq0C2yJKpqs4HAlD5Vq85lmft1ptkKO4UmG
GQIjkfdaqG4twAIftIz3UJ+Gz/jQuuHyPwPVIE2Lefg3GV+iWB3Od8ObmKZGBjnw
AM0FEI2D6I/bv2RofYDd
=C6jp
-----END PGP SIGNATURE-----

--=-ks4JRklZRwiwCSbyzAiQ--

