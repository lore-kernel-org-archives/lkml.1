Return-Path: <linux-kernel-owner+w=401wt.eu-S933658AbXGQRp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658AbXGQRp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757368AbXGQRpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:45:20 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:33340 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758935AbXGQRpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:45:18 -0400
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
From: Zan Lynx <zlynx@acm.org>
To: Rene Herman <rene.herman@gmail.com>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Bodo Eggert <7eggert@gmx.de>, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <469CF3C6.5070907@gmail.com>
References: <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com>
	 <Pine.LNX.4.58.0707161523500.25779@be1.lrz> <469BF104.1040703@gmail.com>
	 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
	 <469BF768.6040200@gmail.com>
	 <2c0942db0707161613lff9c07bpcf002b9139163a86@mail.gmail.com>
	 <469BFDA7.1040204@gmail.com>
	 <2c0942db0707161640h3c3afd7avecd7b3c61c4e7df1@mail.gmail.com>
	 <469C1409.9010305@gmail.com>
	 <20070717161454.GB21538@mediacenter.austin.rr.com>
	 <469CF3C6.5070907@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8VHrOaL9vHHI2pX0HuSJ"
Date: Tue, 17 Jul 2007 11:45:00 -0600
Message-Id: <1184694300.457333.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8VHrOaL9vHHI2pX0HuSJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-07-17 at 18:52 +0200, Rene Herman wrote:
> On 07/17/2007 06:14 PM, Shawn Bohrer wrote:
>=20
> > I can't speak for Fedora, but RHEL disables XFS in their kernel likely
> > because it is known to cause problems with 4K stacks.
>=20
> Okay. So is it fair to say it's largely XFS that's the problem? No proble=
ms=20
> with LVM/MD and say plain ext?

There *are* crashes from LVM and ext3.  I had to change kernels to avoid
them.

I had crashes with ext3 on LVM snapshot on DM mirror on SATA.
--=20
Zan Lynx <zlynx@acm.org>

--=-8VHrOaL9vHHI2pX0HuSJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQBGnQAcG8fHaOLTWwgRAhpHAKCk6xH7G2xnTDrvnktXtm37mvd9BwCdFQP+
YHv6nU2xZoaQuiFtHSDRo4k=
=5wdP
-----END PGP SIGNATURE-----

--=-8VHrOaL9vHHI2pX0HuSJ--

