Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbZKNKbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbZKNKbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 05:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZKNKbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 05:31:42 -0500
Received: from nn7.de ([85.214.94.156]:47175 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbZKNKbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 05:31:41 -0500
Subject: Re: [PATCH] mouse button 1 emulation for mac_hid
From: Soeren Sonnenburg <sonne@debian.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, olh@suse.de,
       Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20091114054246.GF4463@core.coreip.homeip.net>
References: <1257762531.7245.23.camel@no>
	 <20091114054246.GF4463@core.coreip.homeip.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rbIplangJ4jTftC+NR4R"
Date: Sat, 14 Nov 2009 11:31:45 +0100
Message-ID: <1258194705.8728.21.camel@no>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rbIplangJ4jTftC+NR4R
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-11-13 at 21:42 -0800, Dmitry Torokhov wrote:
> Hi Soeren,

Hi Dmitry,

> On Mon, Nov 09, 2009 at 11:28:51AM +0100, Soeren Sonnenburg wrote:
> > (this is a resent with all the people included in the CC that git
> >          blame'd they are the authors).
> >=20
> > Dear all,
> >=20
> > I am not sure what the future of mac_hid is (the source says will be
> > removed, but since 9 years). In case it stays in kernel the attached
> > patch adds support for mouse button 1 emulation. If this driver stays i=
n
> > the kernel I would also suggest to rename it - it is not mac specific (=
I
> > am using this on a netbook).
> >=20
> > Rationale? Broken touchpads, within linux unsupported (multi-)touchpads
> > where click and hold + moving the mouse does not work (yet?).
> >=20
>=20
> I would rather fix the touchpads so they work properly than pile more
> quirks in kernel.

Well I guess this whole mouse button emulation should not exist (not
only not in the kernel). But given that it is hard to fix a touchpad
that has no or only one mouse button ... I don't know.

Anyway, the patch is really small/non-intrusive but if it is not
appropriate  I can - thanks to git - easily have it in some local
branch :)

Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-rbIplangJ4jTftC+NR4R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJK/ocLAAoJEH82z1Wqh6p3li8QAIaG3DaR+3pHcVDwHsmF7D3G
ajCudM8c1HzBfnab2ALRmtg2WQMZeNe2A9GJlvgJQdb9NS81tW/sXKrChERJUjjM
cUI4mZb30RspwNxFzJsDRA9PjrF+TB09AeJRoH35r1KHUqnsvxRgW80N4TzRkszX
emuE0m7MPuGYXl+bwGajbgyiVligStm8LpBP1DdxSJTz4FBS1SYeKK2G9+tAMGgc
43LZoGshPikvLLnO3dX21lb266KVG7dMbX6x1Qd0ryrmzRXLEf+Mim43KxJESUQb
a6ONhv+BM2hdfrXsffacRifZqx/GRG9877Y0RBejBWDgvF1AWktPdK/IFt/r+fTQ
U9ysXOij1t0aix7Hwr7HqaN3R6a59x0972ybYvH6eVD7SBgLqst1ok6yeRJfNkv4
u5K8CfPZ82EqjwPD3R0NG7JK2h+pm0kRVc28drlP/EcFNI7XJL3IO9rKi1y+w/LI
xkEYFA6aESXL6HSKxvEwLTLVPQEsGpbe6SGRUpB463J2vyhQ0pkn1Kb7vsZoHVn6
pswUIjLJX0hdTEMdQhhcGzDrrou27kmrmcAAVEP77QyySjzEaZddpIQyJkv7PE0O
noNCjL25xNIz5E2QUEtM5ZGM1ZTzuKkS+XYFUwIEXNvxyriGdkcjHhMjNwZcVS5I
41T2zpZ8XZop/8LJylUw
=Eb/s
-----END PGP SIGNATURE-----

--=-rbIplangJ4jTftC+NR4R--
