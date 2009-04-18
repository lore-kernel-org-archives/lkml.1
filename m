Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbZDRUXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbZDRUXs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 16:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZDRUXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 16:23:38 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:39853 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbZDRUXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 16:23:38 -0400
Subject: Re: [git pull] Fixes to 2.6.30rc2
From: Eric Anholt <eric@anholt.net>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090418.015905.92829818.davem@davemloft.net>
References: <1240001399.11172.121.camel@gaiman.anholt.net>
	 <20090418.015905.92829818.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bv25eaKn6mHuEgFkOsDj"
Date: Sat, 18 Apr 2009 13:23:36 -0700
Message-Id: <1240086216.11172.2954.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bv25eaKn6mHuEgFkOsDj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-18 at 01:59 -0700, David Miller wrote:
> From: Eric Anholt <eric@anholt.net>
> Date: Fri, 17 Apr 2009 13:49:59 -0700
>=20
> >   git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel drm-in=
tel-next
>=20
> Eric, any plans to ever push your work through David Airlie's DRM
> tree?  I've been watching this for a few weeks and I'm mystified why
> the Intel DRM drier stuff is so special that is always goes seperate.
>=20
> It's seems foolish for David to manage the infrastructure and core DRM
> changes, as well as those for radeon and the other drivers other than
> Intel, which could potentially cause merge issues and conflicts with
> your driver changes.
>=20
> Why not do Intel DRM driver development via his tree?  I just don't
> get it. :-/

Inside of the merge window, I am going through Dave again because he
requested it (though delays meant that I didn't get a major cleanup in
this merge window).  However, Dave is also quite busy, and not stealing
his time every few days to pull my tree for just forwarding bugfixes on
seems to be a win.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-bv25eaKn6mHuEgFkOsDj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknqNsgACgkQHUdvYGzw6ve7YACfVzKzpS/OoyP0m3fejzkRtEIM
9voAnRH43m/AUWer5cgA98m0gzfVO/wW
=7E+Z
-----END PGP SIGNATURE-----

--=-bv25eaKn6mHuEgFkOsDj--
