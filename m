Return-Path: <linux-kernel-owner+w=401wt.eu-S934054AbXLPOSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054AbXLPOSn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 09:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763253AbXLPOSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 09:18:35 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:48554 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbXLPOSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 09:18:35 -0500
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
       Daniel Walker <dwalker@mvista.com>, Ray Lee <ray-lk@madrabbit.org>,
       Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, Ingo Molnar <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org
In-Reply-To: <200712161535.27261.rjw@sisk.pl>
References: <20071213003028.676998182@mvista.com>
	 <200712160027.19950.mb@bu3sch.de> <1197813419.16079.66.camel@johannes.berg>
	 <200712161535.27261.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xerjpFNuFJnS0Oy8d3QU"
Date: Sun, 16 Dec 2007 15:18:13 +0100
Message-Id: <1197814693.16079.68.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xerjpFNuFJnS0Oy8d3QU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > On Sun, 2007-12-16 at 00:27 +0100, Michael Buesch wrote:
> > > On Sunday 16 December 2007 00:18:43 Rafael J. Wysocki wrote:
> > > > Well, the only problem with that is I suspect there are some "newer=
" cards that
> > > > work better with v3 firmware, although they are supposed to support=
 both.
> >=20
> > Impossible. The firmware is only the MAC.
>=20
> OK

I should probably mention though that of course it is (in theory!)
possible that the card works better with bcm43xx, it just never has
happened for all I know.

johannes

--=-xerjpFNuFJnS0Oy8d3QU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2UzpKVg1VMiehFYAQLV2Q/9Hb0RtLa/h2r7rpePCZErpRE8Z+HEXBt7
mZYJ17NzWNEtBnaFzoWlsVs8kBn53odS/VdHV5qTZdCAVWL/hCxFJOEK71MDVMIh
XOPeoAb23V7fibh6tsygnwExbPZbXB9ztmUR/EOnMVDjqNIqxh0/Gs2yYa0g3r4W
CBt/jgGl5Q0wlM7faD0LnkoydmeHok2kl6jPwbe3K2GnljEaRfLLEjHxzDooiIxG
nhbCE/4YAlGA8/WM4vMtdmRflpPoM5Iii2e3YwnBbVYAK6FZ+9kREIKSwYBnnZA/
8Y3tgTQyzB6oPE2WBs61qwNHg+JS85dCPfGgPXsv90Je/6W/yNbSsGZ7xjyeKn85
k5xujz22DHGVN9rNkyVAu2l6NL4OC1Tg7Oqpu3gJEdiZc3O3vZB5siMfPj/rRxKw
iDmyFI3ukSWe/ygS2fu+QAWUFBlKEqbE6dvVkdj316ONi/91jkCrnfOY8lY9aSTv
5dc/4yqssRMwjN+VEzGRnyYSeRtN8f/YvAClzF84NhsI5XA0Er++ra/weU04ZsIj
xR7/XJmGn7OsVaIzvoWjBnyO19HFuvgK/bu4C+8thoNGaym20mY7sgYxXpJRF7h6
22CAwCraYfsG6hythMffdNPLX9Fdud/TnveN7MD7M1okDy20mgbUtLHGteDy4ITN
qyv2BlHLJjM=
=SG9v
-----END PGP SIGNATURE-----

--=-xerjpFNuFJnS0Oy8d3QU--

