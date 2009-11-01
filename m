Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbZKAP3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbZKAP3K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 10:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZKAP3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 10:29:06 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:46685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbZKAP3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 10:29:06 -0500
Subject: Re: wpa2 hangs v2.6.32-rc5-402-gb6727b1. Revert
 7d930bc33653d5592dc386a76a38f39c2e962344 fixed it.
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0911012318000.3549@boston.corp.fedex.com>
References: <Pine.LNX.4.64.0911012318000.3549@boston.corp.fedex.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Hq4RMeDFhL3DJj4zZxAD"
Date: Sun, 01 Nov 2009 16:29:05 +0100
Message-ID: <1257089345.3555.158.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Hq4RMeDFhL3DJj4zZxAD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-11-01 at 23:18 +0800, Jeff Chua wrote:
> wpa2 (wpa_supplicant) hangs v2.6.32-rc5-402-gb6727b1.

Explain?

> Reverting 7d930bc33653d5592dc386a76a38f39c2e962344 fixes it.

Certainly not a good idea, will break when your AP denies association.

johannes

--=-Hq4RMeDFhL3DJj4zZxAD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7ak9AAoJEODzc/N7+Qma9mUQAKDdV5XVlLDqvJyqqbQ5tLX/
kxIfulStBB9YpmydTQmzi2V3a9afiwjyJd5GO4BicquiILYRbCSuGLrKYpuk6zlu
fCSKO/UcdausWsgYyHnCdP6SHNi+cK0edAl6wckVYSlATRZMuS4w1UFsUoUb3nF2
NAp56zfr1cm/3QL1AaRIQZObYymblCvlaj7ZXoKag/BhKATCwbNpOAk6n/oSMjae
42X8iH6JcU+NYTWIzz0h5ibsWdlGNnNUYICaRBAbLYW8M894krvfLxPphLS8aNly
w8mZkUJSpw/Y7gIb63BdVE+PhJhdqexm83G01tPygedwSKrA3Wr9EbRGL77IalzV
20HCTyBDvMRdddjlCkYjw9oEexNSE6Z3/R3tz/sRJ/Lk4WEtEpinBtatMcvS46DH
i0EiQE7HEl2KcayFEf6h5dHQiBDwxdfgvYumboY3txNGrFPr26u4RexVAfu45mhQ
KDCsx1iSYVb+QVK+8Vkow7wb9MKlzrwPE9Sjcl8yK4AzmCG3DL0iJkoctk7UVlN3
j56mBP6AzwfQZunvepnfBzPW/NLkKaK8NXj8plygI/oMUUz4rmK90EQr1j2hRLOH
+EaZEbsnI6tBeZVpjKvQUctsz00TDEXvZwn2U0+kh2DerLZbVIkPFcMqFxozO/6E
18IEGk/T2pZjqs/1LhoW
=Wku8
-----END PGP SIGNATURE-----

--=-Hq4RMeDFhL3DJj4zZxAD--

