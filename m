Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbYJRDuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbYJRDuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 23:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYJRDt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 23:49:56 -0400
Received: from home.keithp.com ([63.227.221.253]:45261 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYJRDtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 23:49:55 -0400
Subject: Re: [git pull] drm patches for 2.6.27-rc1
From: Keith Packard <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: keithp@keithp.com, Eric Anholt <eric@anholt.net>,
       Dave Airlie <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
In-Reply-To: <alpine.LFD.2.00.0810171941120.3438@nehalem.linux-foundation.org>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	 <alpine.LFD.2.00.0810171510170.3438@nehalem.linux-foundation.org>
	 <1224295858.4378.8.camel@vonnegut.anholt.net>
	 <alpine.LFD.2.00.0810171941120.3438@nehalem.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jzk3Tgw4e1Bf/aOi9zjp"
Date: Fri, 17 Oct 2008 20:49:50 -0700
Message-Id: <1224301790.4384.38.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jzk3Tgw4e1Bf/aOi9zjp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-17 at 19:47 -0700, Linus Torvalds wrote:

> Really? None of you use any modern CPU's, or you're _all_ running 32-bit=20
> distros even though your cpu's could support 64-bit ones?

We're lazy, perhaps even lazier than yourself. Given that the whole goal
is to essentially ignore the CPU and get our code running on the GPU,
it's hard to get excited about the kind of kernel we're running on the
CPU.

We've got a bunch of test boxes that run 64-bits, unfortunately, the
people doing builds there appear not to care about warnings. That will
get fixed.

I've also got this new G45 box here; perhaps it's time to enter the 21st
century and run it in native 64-bit mode. It's scary though; I've been
writing window systems for 32-bit machines for thirty years now.

--=20
keith.packard@intel.com

--=-jzk3Tgw4e1Bf/aOi9zjp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBI+VzeQp8BWwlsTdMRAgIRAJ0XGs2AZYkgjYS6E/vzwAjV257kDgCfYP3Y
JTnHNBO10xZ/XuL6M4Pij/c=
=QaRT
-----END PGP SIGNATURE-----

--=-jzk3Tgw4e1Bf/aOi9zjp--

