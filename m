Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbYFQTZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbYFQTZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 15:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbYFQTZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 15:25:03 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:47628 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766AbYFQTZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 15:25:01 -0400
Subject: Re: Oops report for the week preceding June 16th, 2008
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tglx@linutronix.de, linville@tuxdriver.com,
       davej@redhat.com, gregkh@suse.de
In-Reply-To: <20080617153356.GA3510@elte.hu>
References: <4856AFDF.5080901@linux.intel.com>
	 <20080617092023.GA20621@elte.hu>
	 <20080617.022652.76635616.davem@davemloft.net>
	 <20080617153356.GA3510@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Fi2pD4MipdbPVUnHg5I2"
Date: Tue, 17 Jun 2008 21:24:14 +0200
Message-Id: <1213730654.3803.122.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Fi2pD4MipdbPVUnHg5I2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> i have no gripes about the current situation of wireless in linux-next,=20
> other than it all came 1-2 years too late:

Clearly, you don't have a clue about wireless. I'll admit to being
pissed off by statements like this because I personally spent a lot of
time getting wireless code into shape for merging, and it took a long
time.

If we'd have merged the existing wireless drivers 2 years ago, we would
have (at least) four 802.11 stacks in the kernel now, at least two
legally questionable drivers (the ath5k legal situation would probably
never have been cleared up, acx100 still isn't), no uniform API so it
would be impossible to write userspace support tools etc.

johannes

--=-Fi2pD4MipdbPVUnHg5I2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWA9bAAoJEKVg1VMiehFY+okQALEapV1e6uKiirgk1K6SziTz
B9O8SCR6biyxzHzB9nmhvuullZUdY4QvX3vlu1gOqXPgvoB/Ao1A5zxwBTbg3gUz
LlzPDNtILbStg/BK79BFg43N3mgZBeI1w31UeW1ho0N57suJzWRMNaLb1oSvTNoC
/dFWEVmYTViqCZR9hL+8hFvS6StcZRoaOINm0K5RbXWT2E6XB6kjqL499HvXnOOw
eNR+O4MpjpbhYZKCZnClLDKoikwlhzBM/24nycBAVJjn3zhi+7+Te8VlvqkDUhwU
FIxxVAfRny3SyfTZ9iq6JJC7XjxYRMAg0FIj7CwerphOLC1lBULIh/c0p9pEzdxM
Gki5PS1TR8GrzUV6v+o5izrdC0KO5xnCUAvIJ90K88oR8mcLUJkbgJG+nRhJEOTq
EIzREzcgc9615MWGN0TP8uM9naHYrM4tBujnKCP7HjGHuWD11TUZGEClj37eZ53B
huj+/5FirFJeYC1Oi0tS6mKy3n7JLnzR1EtVP3kAsToHXQ4dKWvVrbDQ4GkqtAxH
1Bsoh3ymjaxEnvRT/KrLI/Ze9prsQIQw9xMv97AkrbUkZgiTSOmRC01ZbwR6i4q4
ygoRdpYpz++Fxrp5lh9FANe6kUJTD3gTjRMxIh3CaNaYcJiJ/CQkhbE1QzULcM1e
CBD0Q4d9eGvtfiM275XU
=TYlA
-----END PGP SIGNATURE-----

--=-Fi2pD4MipdbPVUnHg5I2--

