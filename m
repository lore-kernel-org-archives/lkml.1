Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYJVRGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYJVRGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYJVRGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:06:43 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:53028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbYJVRGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:06:42 -0400
Subject: Re: Regression in 2.6.27-git from commit 43ac2ca3840f64
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jouni Malinen <j@w1.fi>, Jouni Malinen <jouni.malinen@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       John Linville <linville@tuxdriver.com>, Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <48FF5933.3080501@lwfinger.net> (sfid-20081022_184755_577051_32659A3C)
References: <48FDFCCA.8040604@lwfinger.net>
	 <20081022072840.GD16005@jm.kir.nu>  <48FF5933.3080501@lwfinger.net>
	 (sfid-20081022_184755_577051_32659A3C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1GFXvLdUWAt+Uo86/Kb7"
Date: Wed, 22 Oct 2008 19:06:29 +0200
Message-Id: <1224695189.30459.6.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1GFXvLdUWAt+Uo86/Kb7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 09:47 -0700, Larry Finger wrote:

> When a utility starts spitting messages that it doesn't understand what t=
he
> kernel is providing _AND_ the commit message does not mention that this w=
ill
> happen, can someone be blamed for thinking it is a bug?

Heh, no, not really. It was fairly obvious us, but I guess we were just
routine-blinded.

> Clearly this is not a regression. Are there plans to update the wireless =
utilities?

I suspect it could just be made to ignore them. Or skip a select few,
but obviously it will never be able to parse all of them...

johannes

--=-1GFXvLdUWAt+Uo86/Kb7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/12RAAoJEKVg1VMiehFYRQoP/0dTv6PJuwpCwwH8CEzDT6sM
kc9m7SyYTK6x78KHzwXZT6npbntMTdkFtT/tXPkcGhqqHE6YboqRl0pkEDWg+FnE
tg/ZmS7IYxmFE+pbqC8iZSHf1OKKycMK96sipj5baKaxEQH25hZdWmBItW0X/QwI
J4JiP2QSnMb+VZK4qnn7zuIgYj2CVfRpax62rwjSVLHULWb3fe1IoxaQL9WgGIzI
ozdlX+ce79mtaldfEabk1/i6bfJtnPbUeie1xJ1BNCTS8amAyzN83SHlam8dcuYz
gZJ5VXLjaNFfMTcpkjBdlprs4p3zNuwQrbrFoS3feGftor7/5pYnJt4EWabmj8n1
VN2XCBgIGaQMkULDsyIbP28WKctEginRDxx33o6yQGijcib/Q4PKr9kpnpa4cAeB
A/BpUxT/6dLVyHhMv1ydxhBJ9RXgZ1J6W2vyyChoR6jFk7Ldc5ptKy/1uzOkS1uF
go269JQfACIB+VJWKnmmfXOFKZrXNy4kVjHsAwDNNkHog2kWwi46h4hjvHXHixAU
YEI9NFRa8v33j5phfSVdV7nq/X3tvbx9/jXC5GFuh9Xxrgtsdg+O4+CIR4O0D1UM
lSdiFT7bh+B3G0zOIcljD2Wx461tFQ//NxhrA8VfGMAP6yCIHLxR4VVBwCPTf5h/
abG2jVV/QLfIhuEBh0xM
=FxQ0
-----END PGP SIGNATURE-----

--=-1GFXvLdUWAt+Uo86/Kb7--

