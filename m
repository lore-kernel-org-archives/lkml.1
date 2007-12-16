Return-Path: <linux-kernel-owner+w=401wt.eu-S934234AbXLPN5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934234AbXLPN5f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 08:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759629AbXLPN50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 08:57:26 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:55241 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbXLPN5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 08:57:25 -0500
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, Daniel Walker <dwalker@mvista.com>,
       akpm@linux-foundation.org, Ray Lee <ray-lk@madrabbit.org>,
       Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, Ingo Molnar <mingo@elte.hu>,
       kjwinchester@gmail.com, linux@bohmer.net
In-Reply-To: <200712160027.19950.mb@bu3sch.de> (sfid-20071215_232959_683038_2539BF80)
References: <20071213003028.676998182@mvista.com>
	 <200712151157.44278.mb@bu3sch.de> <200712160018.45613.rjw@sisk.pl>
	 <200712160027.19950.mb@bu3sch.de> (sfid-20071215_232959_683038_2539BF80)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tGPaogN7FT5N6xMN0QII"
Date: Sun, 16 Dec 2007 14:56:59 +0100
Message-Id: <1197813419.16079.66.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tGPaogN7FT5N6xMN0QII
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2007-12-16 at 00:27 +0100, Michael Buesch wrote:
> On Sunday 16 December 2007 00:18:43 Rafael J. Wysocki wrote:
> > Well, the only problem with that is I suspect there are some "newer" ca=
rds that
> > work better with v3 firmware, although they are supposed to support bot=
h.

Impossible. The firmware is only the MAC.

johannes

--=-tGPaogN7FT5N6xMN0QII
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2UuqqVg1VMiehFYAQL87A//aMiwuzTpOTKWOtxuigPoQqgW8/0Q8/eF
S+rT3J3CmjWTwSQNTVO5iVuVDhLtWbBS6z3rDRPCKqcl8tCcRgkBdU2q3GA/AeTB
SU0KjGaM5UTw7UpnO/aLgzftjFEveLj8D1DIPE5HDJW3L/TFOHwi0g8p4hJyGZfT
5QZ/2/FubcvYyrSmpZuCHZQ8HqKyzW3xvvuLPiOSRdq+YutrkZXQv/fFCib+mDf1
6lUT3dOp6vZvSnM9OLzlbKUwFUevEtzU46gdnAbqgwarnX9VZUhpcVD2vsb0i3Cg
0Hg80i4bqQdOfrfgHXVAXu1xaUMkHh3bviF8W0ns0vN9Mh+REoRAi9u03IjeEZba
iUuNwGjNwXhJT/bXRmS5xrdcQLdRjg4dbOw+HSrrtLBxo+HDIfKBzY6HJHGSr8An
wQu659l4EEebUBVc3vU+X0Ni2qEPpKdDRU0HvoZA35bGI2PDa6LKqWN9ktr3LP1w
64AQfv3rxlhfhOgg3BJlSsra8wHwHn+RTWu8bUSOhz8inVQitPTl90TZmSarb1ua
acjQzSZTHD+Rq9kwmBoEZMMZD9lBg4qtQlVr4tQvJmzjbU/RSdgTET3qDw98raAS
bopypeDCPAmnz8qhJKHxPmkdnYvJ7Mu9jndsO0fh/we217kR4CxbKpq6c1qTKq/V
eUNKFHTtGv0=
=sWAP
-----END PGP SIGNATURE-----

--=-tGPaogN7FT5N6xMN0QII--

