Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbZLNJA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbZLNJA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZLNJA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:00:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53252 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbZLNJAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:00:55 -0500
Date: Mon, 14 Dec 2009 20:00:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: sparc tree build warning
Message-Id: <20091214200048.34df8acf.sfr@canb.auug.org.au>
In-Reply-To: <20091213.234036.26987805.davem@davemloft.net>
References: <20091214163338.f811722f.sfr@canb.auug.org.au>
	<20091213.234036.26987805.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Dec_2009_20_00_48_+1100_yWQBckt9GHOFOAhb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Dec_2009_20_00_48_+1100_yWQBckt9GHOFOAhb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Sun, 13 Dec 2009 23:40:36 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 14 Dec 2009 16:33:38 +1100
>=20
> >     inlined from 'pktgen_if_write' at net/core/pktgen.c:867:
> > arch/sparc/include/asm/uaccess_32.h:276: warning: call to 'copy_from_us=
er_overflow' declared with attribute warning: copy_from_user() buffer size =
is not provably correct
>=20
> BTW, you should be getting the same exact warnings on x86
> 32-bit with gcc-4.4 or later.

Yeah, similar ones indeed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Dec_2009_20_00_48_+1100_yWQBckt9GHOFOAhb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksl/sAACgkQjjKRsyhoI8wYJgCgtS53fQ2ztYfw+KXbnw3C77OR
cy4AoKyoeWI9KysAT2ZeKde12B44WEjH
=Arfv
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Dec_2009_20_00_48_+1100_yWQBckt9GHOFOAhb--
