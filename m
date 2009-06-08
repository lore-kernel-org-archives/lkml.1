Return-Path: <linux-kernel-owner+w=401wt.eu-S1751799AbZFHGgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbZFHGgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 02:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZFHGgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 02:36:05 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:32912 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZFHGgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 02:36:04 -0400
Subject: Re: [Bug #13306] hibernate slow on _second_ run
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <D9VoutSOyXP.A.u-H.Ra7KKB@chimera>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.u-H.Ra7KKB@chimera>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Pw5MQ5+MXSaMjMRO+pXz"
Date: Mon, 08 Jun 2009 08:36:01 +0200
Message-Id: <1244442961.11457.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Pw5MQ5+MXSaMjMRO+pXz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-06-07 at 11:52 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>=20
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13306
> Subject		: hibernate slow on _second_ run
> Submitter	: Johannes Berg <johannes@sipsolutions.net>
> Date		: 2009-05-14 09:34 (25 days old)

I'm still seeing this, did you get a chance to look at the ftrace?

johannes

--=-Pw5MQ5+MXSaMjMRO+pXz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKLLFOAAoJEODzc/N7+QmaHycQAILsevi+FrWBDk23U3QGCSdb
/Bpe4AwvXlGEx9tQ0gO7GEAQucXZPnY8ivHUTkp+/sWmQCAGhoK3pjuF+7IHdOhN
VFQCndInO4/VaJFx2Uz52wLvCKfdikK8ueTSIpUbzf8STJRSFlgGbsfqx5UbeIkD
1B0N+P5qUssdSj9a6rc3AwDaIy9a/GqlPLQb+WQEeRc+WjbEzZANnM4HXvNLiK98
MY2+tz0pP4VeUGQDDJI6gaqVW+M/UdPWHfveAuB5Jfnld90YfXsNH4c5PRUVqBJo
RKGYGpgj5SSPLCu2txNh/EohioUNgWLWo6D+4uf/Igf2nk8UXC5XSC37tCLWHkCU
FpMgm+1k8dNgjlBBjqDmbxzWeheCjAES2HkAzPGlzeTir+X1zuvYyyKTPhSN/Ood
bRo0yUnj9pSL9UjmitaNnKRTlWq8KR8tajVLYIYOaie4+zmrbfJgPnEihREiGxNh
APcdK8tCsTS8TBrSC6KGYNxahUfKG/rwa3NjeV4QaWQYfV4p5XsHRMguByfFClvc
fbmlBpefJHluOiTLsU2SnXPU+/aULuyP2kpjim6qEyWJIgL8LbKGRBGr6CmosfY0
cs4WNGou+ujZXYHecO7YJZBucdU/y/W+fHa45NJUq5hAPGpFej/Swb7XHsjxIDbe
vdk7POK70pEx5psNY2LE
=D2ID
-----END PGP SIGNATURE-----

--=-Pw5MQ5+MXSaMjMRO+pXz--

