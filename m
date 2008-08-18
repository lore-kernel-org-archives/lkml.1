Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbYHRCAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbYHRCAp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 22:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYHRCAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 22:00:36 -0400
Received: from ozlabs.org ([203.10.76.45]:48777 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbYHRCAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 22:00:35 -0400
Subject: Re: bug in lmb_enforce_memory_limit()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: David Miller <davem@davemloft.net>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080815.195724.238982506.davem@davemloft.net>
References: <1218713213.10673.17.camel@localhost>
	 <20080815.152501.193746275.davem@davemloft.net>
	 <1218847582.7576.6.camel@localhost>
	 <20080815.195724.238982506.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-c79z47Sp4XdFXzhOzGt9"
Date: Mon, 18 Aug 2008 12:00:32 +1000
Message-Id: <1219024832.8115.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-c79z47Sp4XdFXzhOzGt9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-08-15 at 19:57 -0700, David Miller wrote:
> From: Michael Ellerman <michael@ellerman.id.au>
> Date: Sat, 16 Aug 2008 10:46:22 +1000
>=20
> > On Fri, 2008-08-15 at 15:25 -0700, David Miller wrote:
> > > Sounds great.  Mind if I push the following to Linus?
> >=20
> > Looks good to me.
> >=20
> > I'll test it on Monday. I don't know if I have a system with memory
> > holes to test on, but I take it you do?

Works for me.

Although I can't find a system with holes (the newer hypervisors make
things look contiguous I think), so I can't really test the interesting
case.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-c79z47Sp4XdFXzhOzGt9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIqNfAdSjSd0sB4dIRAuLoAKDGkcAyDoQIvDQDulY9hVlH7ijvRACfSdG7
AhnupINivEMKKWB9nEwUTrs=
=r4o0
-----END PGP SIGNATURE-----

--=-c79z47Sp4XdFXzhOzGt9--

