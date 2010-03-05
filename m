Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0CEPlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:41:47 -0500
Received: from light.bluelinux.co.uk ([195.10.223.138]:40247 "EHLO
	light.bluelinux.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab0CEPlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:41:46 -0500
Date: Fri, 5 Mar 2010 17:41:43 +0200
From: Daniel Stone <daniel@fooishbar.org>
To: Matt Turner <mattst88@gmail.com>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Ben Skeggs <skeggsb@gmail.com>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, dri-devel@lists.sf.net,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Making Xorg easier to test (was Re: [git pull] drm request 3)
Message-ID: <20100305154143.GD2505@tempa>
Mail-Followup-To: Daniel Stone <daniel@fooishbar.org>,
	Matt Turner <mattst88@gmail.com>,
	"Carlos R. Mafra" <crmafra2@gmail.com>,
	Ben Skeggs <skeggsb@gmail.com>, Dave Airlie <airlied@linux.ie>,
	linux-kernel@vger.kernel.org,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>, dri-devel@lists.sf.net,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com> <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain> <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com> <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain> <1267748927.3496.6.camel@nisroch> <20100305064955.GA6453@elte.hu> <84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com> <20100305074407.GC19703@elte.hu> <20100305100030.GA4970@Pilar.aei.mpg.de> <b4198de61003050722s54478b08q31c4eb7fd892fb90@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qbvjkv9qwOGw/5Fx"
Content-Disposition: inline
In-Reply-To: <b4198de61003050722s54478b08q31c4eb7fd892fb90@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qbvjkv9qwOGw/5Fx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 05, 2010 at 10:22:27AM -0500, Matt Turner wrote:
> On Fri, Mar 5, 2010 at 5:00 AM, Carlos R. Mafra <crmafra2@gmail.com> wrot=
e:
> > Why can't there be a 'Linus Torvalds' for Xorg accepting patches from v=
arious
> > maintainers and keeping the whole thing tied up? Why can't it mimic the
> > 'make menuconfig' way of selecting what to compile to have the guarante=
e that
> > the whole thing will simply work nicely together?
>=20
> You must not follow X development at all. His name is Keith Packard.

Except that if you look at X lately, you'll realise that we do not have
the resources to even come close to being able to do this properly.  We
struggle to support what we have already today, and we've still been
hoping to create a real API, instead of the sad joke that is
/usr/include/xorg/*.h, for the last few years.  But we don't have enough
people (or at least enough people who aren't busy with the other parts
of their day jobs, or kids, or burnout, or whatever) to do it.

I understand that you guys are upset about this, so maybe you'd like to
donate, say, 10% of your developer base to help out? That'd be pretty
ace.

Cheers,
Daniel

--Qbvjkv9qwOGw/5Fx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuRJjcACgkQUVYB1rKAgJTsagCglUyqTapwHyIbBKdm8u6DjKdE
SUEAnRKY8X1t/zhywgNQNJ8H9bD80ZIA
=aAAj
-----END PGP SIGNATURE-----

--Qbvjkv9qwOGw/5Fx--
