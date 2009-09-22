Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbZIVLwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbZIVLwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756265AbZIVLwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:52:11 -0400
Received: from ozlabs.org ([203.10.76.45]:49196 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756264AbZIVLwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:52:10 -0400
Subject: Re: [PATCH] perf_event, powerpc: Fix compilation after big
 perf_counter rename
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1253606415.7103.216.camel@pasglop>
References: <19128.4280.813369.589704@cargo.ozlabs.ibm.com>
	 <1253584591.7103.197.camel@pasglop>  <20090922072834.GA25470@elte.hu>
	 <1253606415.7103.216.camel@pasglop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Vp5S5YL/PSnSyWsEdaX9"
Date: Tue, 22 Sep 2009 21:52:12 +1000
Message-Id: <1253620332.10476.4.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Vp5S5YL/PSnSyWsEdaX9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-22 at 18:00 +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2009-09-22 at 09:28 +0200, Ingo Molnar wrote:
> >=20
> > Nevertheless you are right that i should have caught this particular=20
> > PowerPC build bug - i missed it - sorry about that!
> >=20
> Allright. Well, to help in general, we are setting up a build-bot
> here too that will build -tip HEAD for at least powerpc daily with
> a few configs too.

Results here:

http://kisskb.ellerman.id.au/kisskb/branch/12/

cheers

--=-Vp5S5YL/PSnSyWsEdaX9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkq4umgACgkQdSjSd0sB4dKs0gCfdkt5/dnFd6/SYu7ksFZWX4Vn
e5wAn3goUGRJQidvvBpiugwLpnsq9HRm
=aF3y
-----END PGP SIGNATURE-----

--=-Vp5S5YL/PSnSyWsEdaX9--

