Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbYK1VgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbYK1VgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 16:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYK1VgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 16:36:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53933 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbYK1VgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 16:36:08 -0500
Date: Sat, 29 Nov 2008 08:35:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <len.brown@intel.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, x86@kernel.org
Subject: drivers/x86 (Was: Re: linux-next: Tree for November 28
 (misc/tc1100))
Message-Id: <20081129083550.3c23af37.sfr@canb.auug.org.au>
In-Reply-To: <4930307C.30106@oracle.com>
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au>
	<4930307C.30106@oracle.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__29_Nov_2008_08_35_50_+1100_zu18iXK=7RyZcY/R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__29_Nov_2008_08_35_50_+1100_zu18iXK=7RyZcY/R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Fri, 28 Nov 2008 09:55:08 -0800 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> make[2]: *** No rule to make target `drivers/misc/tc1100-wmi.o', needed b=
y `drivers/misc/built-in.o'.
>=20
> on allmodconfig & allyesconfig for i386.
>=20
> On, moved to drivers/x86/.  Someone needs to clean up drivers/misc/Makefi=
le.

Just wondering where the move to drivers/x86 was discussed, (reviewed and
tested) and why the change is in the acpi tree and not the x86 tree?

I am not saying it should not be done (I haven't looked enough to have an
opinion).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__29_Nov_2008_08_35_50_+1100_zu18iXK=7RyZcY/R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkwZDYACgkQjjKRsyhoI8zPNwCfWKpai2l5ACY6syZ66QEf87Jf
MVMAn1dM4hL079n9FFk/21Dt97nKPAI0
=sBRS
-----END PGP SIGNATURE-----

--Signature=_Sat__29_Nov_2008_08_35_50_+1100_zu18iXK=7RyZcY/R--
