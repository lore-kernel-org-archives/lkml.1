Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZDTGAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZDTGAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 02:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZDTGAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 02:00:41 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:49068 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbZDTGAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 02:00:40 -0400
Subject: Re: [git pull] Fixes to 2.6.30rc2
From: Eric Anholt <eric@anholt.net>
To: Dave Airlie <airlied@gmail.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <21d7e9970904182347m1dbb611dp3a71f16b0fd82bb7@mail.gmail.com>
References: <1240001399.11172.121.camel@gaiman.anholt.net>
	 <20090418.015905.92829818.davem@davemloft.net>
	 <1240086216.11172.2954.camel@gaiman.anholt.net>
	 <21d7e9970904182347m1dbb611dp3a71f16b0fd82bb7@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OpTqbHBgpm6gO9MTbGui"
Date: Sun, 19 Apr 2009 23:00:24 -0700
Message-Id: <1240207224.11949.12.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OpTqbHBgpm6gO9MTbGui
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-19 at 16:47 +1000, Dave Airlie wrote:
> On Sun, Apr 19, 2009 at 6:23 AM, Eric Anholt <eric@anholt.net> wrote:
> > On Sat, 2009-04-18 at 01:59 -0700, David Miller wrote:
> >> From: Eric Anholt <eric@anholt.net>
> >> Date: Fri, 17 Apr 2009 13:49:59 -0700
> >>
> >> >   git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel drm=
-intel-next
> >>
> >> Eric, any plans to ever push your work through David Airlie's DRM
> >> tree?  I've been watching this for a few weeks and I'm mystified why
> >> the Intel DRM drier stuff is so special that is always goes seperate.
> >>
> >> It's seems foolish for David to manage the infrastructure and core DRM
> >> changes, as well as those for radeon and the other drivers other than
> >> Intel, which could potentially cause merge issues and conflicts with
> >> your driver changes.
> >>
> >> Why not do Intel DRM driver development via his tree?  I just don't
> >> get it. :-/
> >
> > Inside of the merge window, I am going through Dave again because he
> > requested it (though delays meant that I didn't get a major cleanup in
> > this merge window).  However, Dave is also quite busy, and not stealing
> > his time every few days to pull my tree for just forwarding bugfixes on
> > seems to be a win.
>=20
> btw which cleanup, I seem to remember it arriving after the merge
> window had opened.
>=20
> The theory is the code was in my tree before Linus opened the window
> or it doesn't
> get=20

Yeah, it was early merge window iirc, the mechanical
drm_malloc/drm_calloc/drm_free nuke.  It really needs to die.  In a
fire.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-OpTqbHBgpm6gO9MTbGui
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknsD3YACgkQHUdvYGzw6vfujgCfWbW5BlgPfD1FCjAh4MvlsGfo
3O8An3xfodP3Rsshzytah++emta7HQLw
=OzcQ
-----END PGP SIGNATURE-----

--=-OpTqbHBgpm6gO9MTbGui--
