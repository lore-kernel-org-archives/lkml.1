Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbXCEQek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbXCEQek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbXCEQej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:34:39 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:36288 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752780AbXCEQej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:34:39 -0500
Subject: Re: 2.6.21-rc2-mm1
From: Zan Lynx <zlynx@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200703041007.31800.m.kozlowski@tuxland.pl>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	 <200703041007.31800.m.kozlowski@tuxland.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LnFBx0vIYBc7jEvtWz7F"
Date: Mon, 05 Mar 2007 16:34:37 +0000
Message-Id: <1173112477.25362.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LnFBx0vIYBc7jEvtWz7F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-03-04 at 10:07 +0100, Mariusz Kozlowski wrote:
> Hello,
>=20
> 	I'm experiencing weird system hangs with recent -mm. After a few hours o=
f uptime for no
> obvious reason system hangs and is (almost) unusable until reset.

This is similar to what I have been experiencing.  I have not been able
to get my laptop to run 2.6.21-rc2-mm1 for more than 5 minutes.  The
last kernel I had working was 2.6.20-rc6-mm3.

The problems may be multiple.  Whenever I load the new bcm43xx drivers
and do *anything* with iwconfig, it locks hard.  No keyboard LEDs, and
sysrq does not work.

While I had it in single-user mode, no bcm43xx drivers loaded, I was
using make menuconfig to try a different configuration, and it locked
hard for no apparent reason.  Again, no keyboard LEDs, no sysrq.

Laptop fans come on full speed after a bit, so something is still
happening in the BIOS.
--=20
Zan Lynx <zlynx@acm.org>

--=-LnFBx0vIYBc7jEvtWz7F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.2 (GNU/Linux)

iD8DBQBF7EadG8fHaOLTWwgRAtcqAKCSbqww29AP7nZxaHSh4LYBV7vBZwCfYgU3
UG12xwWYsEqDPCGGRYhR+uo=
=RydF
-----END PGP SIGNATURE-----

--=-LnFBx0vIYBc7jEvtWz7F--

