Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbYJRHui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbYJRHui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 03:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYJRHu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 03:50:29 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:50124 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYJRHu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 03:50:29 -0400
Subject: Re: [git pull] drm patches for 2.6.27-rc1
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <alpine.LFD.2.00.0810171941120.3438@nehalem.linux-foundation.org>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	 <alpine.LFD.2.00.0810171510170.3438@nehalem.linux-foundation.org>
	 <1224295858.4378.8.camel@vonnegut.anholt.net>
	 <alpine.LFD.2.00.0810171941120.3438@nehalem.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oRxTAPOyBhDppQgu9B6i"
Date: Sat, 18 Oct 2008 00:49:02 -0700
Message-Id: <1224316142.4378.17.camel@vonnegut.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oRxTAPOyBhDppQgu9B6i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-17 at 19:47 -0700, Linus Torvalds wrote:
>=20
> On Fri, 17 Oct 2008, Eric Anholt wrote:
> >=20
> > Yeah, none of us are on x86-64, so we missed those warnings in testing.
>=20
> Really? None of you use any modern CPU's, or you're _all_ running 32-bit=20
> distros even though your cpu's could support 64-bit ones?
>=20
> I would suggest at least _somebody_ in the intel graphics team try to get=
=20
> with the times.. I realize that Otellini was saying "Nobody needs 64-bit=20
> on the desktop" a few years ago, but he was full of sh*t then, and it's=20
> certainly not remotely true now.
>=20
> It's not being disloyal to your CEO, really. I'm pretty sure nobody will=20
> be fired just for ignoring that whole "640kB^H^H^H^H^H32-bits should be=20
> enough for everybody" idiocy.

Writing 3D drivers means running 3D games.  Running 3D games
unfortunately means running a lot of 32-bit userland as the fun stuff is
binary-only.  So I stick to a 32-bit system, becuase past experience
trying to run both on the same system has been misery.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-oRxTAPOyBhDppQgu9B6i
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkj5lO4ACgkQHUdvYGzw6vfiyQCfQSnJLeXYrzvbQM7qK0zaL13W
gqUAni82mqQdq57lxyPVmfus8C0BXrwa
=rTXY
-----END PGP SIGNATURE-----

--=-oRxTAPOyBhDppQgu9B6i--
