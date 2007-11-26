Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbXKZQTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbXKZQTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbXKZQSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:18:53 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46577 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbXKZQSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:18:53 -0500
Date: Tue, 27 Nov 2007 03:18:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Loic Grenie <loic.grenie@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] Add CONFIG_BITS to remove the test in
 arch/x86/Makefile
Message-Id: <20071127031844.b8f36b7c.sfr@canb.auug.org.au>
In-Reply-To: <E1Iwe87-0003X7-47@localhost>
References: <E1Iwe87-0003X7-47@localhost>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Nov_2007_03_18_44_+1100_gNkqzyeehEy1O55v"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Nov_2007_03_18_44_+1100_gNkqzyeehEy1O55v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Nov 2007 14:36:07 +0100 Loic Grenie <loic.grenie@gmail.com> wrot=
e:
>
>     I propose the following patch to arch/x86/Makefile and Kconfig.
>=20
> Actions:
>=20
>      - Add a BITS variable to Kconfig which takes value 32 or 64 according
>        to 64BIT.

Linus' suggestion was WORD_SIZE and that is what we have already used in
powerpc.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Nov_2007_03_18_44_+1100_gNkqzyeehEy1O55v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHSvHpTgG2atn1QN8RAic6AKCP5YDTTYkdV//inC5r6z8nL9ZVegCfWj5y
9zBdTLJEJXjHeN2JD0YfFgg=
=pRJz
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Nov_2007_03_18_44_+1100_gNkqzyeehEy1O55v--
