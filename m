Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547Ab0ALWbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab0ALWbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 17:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959Ab0ALWby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 17:31:54 -0500
Received: from nn7.de ([85.214.94.156]:41905 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab0ALWby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 17:31:54 -0500
Subject: Re: [Bug #15043] Display goes off with i915.powersave=1
From: Soeren Sonnenburg <sonne@debian.org>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <omZ8aBZReyD.A.9pF.sMlSLB@chimera>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
	 <omZ8aBZReyD.A.9pF.sMlSLB@chimera>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-If42iljmhSSN2W94bRZd"
Date: Tue, 12 Jan 2010 23:31:50 +0100
Message-ID: <1263335510.4249.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-If42iljmhSSN2W94bRZd
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-01-10 at 23:32 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>=20
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D15043
> Subject		: Display goes off with i915.powersave=3D1
> Submitter	: Soeren Sonnenburg <sonne@debian.org>
> Date		: 2010-01-10 20:09 (1 days old)
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D126315457519505&w=3D4

I just recognized that only the *internal* display (i.e., LVDS1) goes
dark while the external display VGA1 stays on. In addition there is some
random screen flickering often before the display turns off...

Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-If42iljmhSSN2W94bRZd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJLTPhVAAoJEH82z1Wqh6p3W1QP/RqaifwpiC2/NBQ554BCrJyH
0Q/XhaV1ILrg09Gew6tG2kMUDhKL81k8wxoIm3hsVAmMAo57f3dyRvhux4qJN8Vw
1WB4zFzjsKxV6FPsPNb1KzkUf9M3bJ8AcibPy3WqmC4Z89kV0ThXLovubnHFkSMQ
gLNpyERfIOr0et7VIVltvrkZtzqy2mEa0ZArd4uA+9H3wCZG3Nr2eWti0nlTKrWL
MGILf0t5ayo2fElXbSk8/mDCjmfi0GGoqpMkkfFkWKRvYNQaskJoWHCkbRCjeqmm
eW9cXQVjxIoBJpyfJ6HLc+E19StSp09xdo/Pau6i9DP9/lmgeFUj46lifD8bSjwf
qPsCIJlQ/fNOjzK4sUkyFEkgWAH3melzC1mX4uno6R8mae+cSEwnklrjVj0svJSi
0R4qNvbdSD0VF53y02PTH6IojsIeLXtu7IHf0nPVh4uko9FQXTxt4AByJdK0eK5l
D+ZsYLd4W248eyRRQ/e/e02eYSfc1Wcyu2rBixPx46KtS1ZfeZirKr9erp5I2Lld
U8SEE4qH1OQClSMbfaGp8ZJPtvoL7t7lLpLmKGQDsp3m/H2TpIlt1d/+n5Zouy0Z
3aI5C9uB67G24yTjmL/4gio6hylm6J19sO7e7kV5CBOwN77oTVCkVQizEhtg8kIN
/LsSXhxLZlEv2Il9UFGD
=duxM
-----END PGP SIGNATURE-----

--=-If42iljmhSSN2W94bRZd--
