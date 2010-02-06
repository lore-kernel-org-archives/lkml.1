Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750898Ab0BFFLJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 00:11:09 -0500
Received: from nn7.de ([85.214.94.156]:54038 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab0BFFLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 00:11:07 -0500
Subject: Re: [Bug #15043] Display goes off with i915.powersave=1 after
 suspend-resume
From: Soeren Sonnenburg <sonne@debian.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       dri-devel@lists.sourceforge.net
In-Reply-To: <20100205112952.01affddb@jbarnes-piketon>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
	 <d3IDKWHT5gE.A.-nC.G8hZLB@chimera> <1265314137.10203.0.camel@no>
	 <201002042142.02127.rjw@sisk.pl>  <20100205112952.01affddb@jbarnes-piketon>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EufWK+kipqE7FonpDWXR"
Date: Sat, 06 Feb 2010 06:11:02 +0100
Message-ID: <1265433062.26151.1.camel@no>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EufWK+kipqE7FonpDWXR
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-02-05 at 11:29 -0800, Jesse Barnes wrote:
> On Thu, 4 Feb 2010 21:42:02 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>=20
> > On Thursday 04 February 2010, Soeren Sonnenburg wrote:
> > > On Mon, 2010-02-01 at 01:22 +0100, Rafael J. Wysocki wrote:
> > > > This message has been generated automatically as a part of a
> > > > report of recent regressions.
> > > >=20
> > > > The following bug entry is on the current list of known
> > > > regressions from 2.6.32.  Please verify if it still should be
> > > > listed and let me know (either way).
> > > >=20
> > > >=20
> > > > Bug-Entry	:
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=3D15043
> > > > Subject		: Display goes off with i915.powersave=3D1
> > > > after suspend-resume Submitter	: Soeren Sonnenburg
> > > > <sonne@debian.org> Date		: 2010-01-10 20:09 (22
> > > > days old) References	:
> > > > http://marc.info/?l=3Dlinux-kernel&m=3D126315457519505&w=3D4
> > >=20
> > > yes still exists in current git.
> >=20
> > Thanks for the update.
>=20
> Just updated the corresponding FDO bug
> (https://bugs.freedesktop.org/show_bug.cgi?id=3D24314).  There are some
> hw bugs related to FBC handling on 945GM though, so we may have to
> disable it on some machines.

FYI: With the patch from #14897 it was working for the last day and a
half at least...

Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-EufWK+kipqE7FonpDWXR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJLbPnbAAoJEH82z1Wqh6p31YwQAM6QCCMkm+hBKbqLRr9Ye+9F
AciZNWqle2B3zjWk9CdEgRocDJQ2WB4EQNulH3/RuPocCZE3ay4vjV0oLO6LS/u3
SrA8MX0uS6JgBt7ab+kRE8xUfoInIZS4h0Jjfi2nRzk2F5MtSf849i/aixqTPn7S
VooCfzRJdk4tAhvvJ6yIvyW8BNFt4ohTPwh80Z9wywBS4tD0fdd9Klihy7RFj6TD
PxzmCUBVWzSb3gs9YBL7uvBBjtqfppbD1LfPNS3PRG01wG2x5vq/1UimJ3IxuHG+
lgGb6TmjQYbI1Chd4r1uAYGowBYmIX2MBAeaKtFmKyvcxBjjoZae5++Kk7+2KADf
UWAM4kNQgfxQz/7Kv1Xpjz8fZ2QpGBw1u+n8lHRacHKxHiAwvGq/tLLGcIAV0sCT
dIEmR/lGCRAwxBdKu0/kHUTBwESZtasIy2uhaOiW2mF/D6teOdGW97UE8yRJF7os
VKtWEaAB1vYyahqT11uUxKVzbtnpTu9xnVg6mpN2+3X2KJvciWJHSoFCEuLVYEb/
8R3f2Q+yky0IrqRxfNzdAnztM8rCMtNYgKD/2QJO5ULsrawzwdHqmz3UNgW0D71C
IXT7QF+XusN+o1oME0KU1xBoxboWmyrTDraZxBSEo1PBKbJBMejS2FZqxtS6s/sA
ejLvLTcGAv3XUjxrUp3U
=I8bm
-----END PGP SIGNATURE-----

--=-EufWK+kipqE7FonpDWXR--
