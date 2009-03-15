Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbZCOTC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbZCOTC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476AbZCOTCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:02:47 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:40203 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbZCOTCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:02:46 -0400
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <alpine.LFD.2.00.0903151136310.3131@localhost.localdomain>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
	 <b6a2187b0903141958u9dae0fdk1f44b387108b99e4@mail.gmail.com>
	 <b6a2187b0903142006u546fad9eme66f9ea7b464b81f@mail.gmail.com>
	 (sfid-20090315_040645_344726_0E746861) <1237140665.24621.2.camel@johannes.local>
	 <alpine.LFD.2.00.0903151136310.3131@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ty5qBmsrFy6A05TEzAuf"
Date: Sun, 15 Mar 2009 20:01:22 +0100
Message-Id: <1237143683.24621.7.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ty5qBmsrFy6A05TEzAuf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-15 at 11:44 -0700, Linus Torvalds wrote:

> Johannes - "not believable" is simply not an argument. If Jeff can show a=
=20
> difference, then your disbelief is totally irrelevant, and clearly shows=20
> that you are basing your beliefs on incorrect assumptions (like some=20
> specific version of firmware that isn't the whole story).

Linus, Jeff is totally unbelievable here -- I just realised that the
commit he quotes doesn't even change the driver he's working with.

johannes

--=-Ty5qBmsrFy6A05TEzAuf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJvVCAAAoJEKVg1VMiehFYC/oP/18iaAIm9hloJMk3hiw9txt8
Rrf7ltM/C71hX880Vz9gCFZeF2I0h09Wuv91mVPDPSXCpBS/9lwAB1JWoLYpBMnl
NovC3y1SI7eRNrfjjLpPzOeSh8GWN2TMr63+pcdCzkkGmw4Bg7Q+EPeT0FV/azif
9yxu6MsC88xaVOsH/AXHmL+KLtOUs3NIcqBxn9NLR38YvNhPou7ihbVuZ5Rbulo8
sR5rcWPK9uYAZharvfPWkIgPsPOejpFOXvB+aAGBxHPro4/4bOvKb24/Ga/zoEUv
zSwERpiGohVTmOiHVYw+gxN7Vk8WZl2kc4Pi0u6jM2CG8rZYBUU/L/ZUP09lpBus
8ffLA3VRaJA4dKQPvjIoHJGq5HjDVv+fmRMcL0HH2IJk5BbUYX3yLBdPfOd8LqzG
1nAOX1vFQTRB6TZrd83LbZOSwRtIQpqdF8dPoCVlKIhl1gDA4Q8vdgwPkShxGM28
5K1yz4rUR/U9CayX1NRfKGaeMzr3DQQZHg4Wll1Oy+Cs+QxRrHEq005n2NKUkqff
SXSIQypK6PkgeLCg4G3UzojuDweoXYIRR1EDftPkL5lknaNbAdxT1DY931D4Wh3/
nHiSEK+VasnhMPPpNXYCX03i3VFwcxR1KB3RHF5iKYBYXBdrd44MMMdyiOV32Jvx
vu6u1odGf2SLY3W7UknF
=esYI
-----END PGP SIGNATURE-----

--=-Ty5qBmsrFy6A05TEzAuf--

