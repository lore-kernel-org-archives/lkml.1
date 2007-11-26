Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbXK0NHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbXK0NHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 08:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbXK0NHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 08:07:33 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:59281 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbXK0NHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 08:07:33 -0500
Subject: Re: time accounting problem (powerpc only?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>
In-Reply-To: <1195814816.4149.94.camel@johannes.berg>
References: <1195814816.4149.94.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LPjZDLP2bIhoh/7P5BtP"
Date: Tue, 27 Nov 2007 00:55:14 +0100
Message-Id: <1196121315.6058.0.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LPjZDLP2bIhoh/7P5BtP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> On my powerbook, with NO_HZ and HIGH_RES_TIMERS, I observed recently
> that powernowd would not ever switch between CPU speeds.

Also happens without NO_HZ (with HIGH_RES_TIMERS).

johannes

--=-LPjZDLP2bIhoh/7P5BtP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0tc4aVg1VMiehFYAQLO4Q//Qm3GtSf8MqR0DC7/qiQVik9+qIHiA8CE
7n5fUOZ8yJWmXkbD4IHlbwgMCHLWOw6GfT1ziZCdLtpIGjTz3zkL9J7Us9LZv168
+uuI0pTdmxgy1lqqYobsNVHxb7XDRBmL6RY5l5yCX+DSnfwOL0m7ASnuts+7+2fK
5oOcdzN6zLykb4EN8WtzghKz8MSVvHwcJvxp6cfRahmyPp+Ub4CrTIvQUupg2X5T
dfEm6y6yjeqz8pA8HI2JAImWUgQ3OfzQNLc2id7SQ5KHTbAbXdW/cAxKLxThO/qH
kQ2Yolf5Pv9wnlfY0kLYvn83jjWr+8qRJJDB/kCyEoyuxh5zH0yb+e4Vy5nC7tHn
AXGJrTzAV53ojoI0GUhyv/JxVlEL3GBMkM8z0nmqlK5Sp+wtWy1HfKiGSrqwrzt+
0p25rNba5yGMtut9nFlMhDBk6ekGG7MTuYCVeXOmMNFlLbCroMAitjZpvn7Nx/2g
Wavt3jWDh77yZkym5wNrM4U2DNASAiDctP895zjBZ3aq8pTv+OxRQPuWvqgl6fvG
TGIP5Akuhqu9C4ceNq9eM8mpw4WngGIeGmQxLuPSXJoASzENQRNEyKmWnIYFgYwp
znvln1L54z0yVhhpAFwbnWg8y53XSVvJ+53tg1ugsycYoXrRP9BSVZUSRYnXjGuo
gaKcC1fO1ZM=
=/uxl
-----END PGP SIGNATURE-----

--=-LPjZDLP2bIhoh/7P5BtP--

