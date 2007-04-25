Return-Path: <linux-kernel-owner+w=401wt.eu-S933230AbXDZHSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbXDZHSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933247AbXDZHSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:18:47 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:57826 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238AbXDZHSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:18:45 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Adrian Bunk <bunk@stusta.de>,
       Ingo Molnar <mingo@elte.hu>, Christian Hesse <mail@earthworm.de>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070425213049.GF17387@elf.ucw.cz>
References: <20070419070437.GA25211@elte.hu>
	 <20070425192512.GZ3468@stusta.de>
	 <alpine.LFD.0.98.0704251231111.9964@woody.linux-foundation.org>
	 <200704252220.57792.rjw@sisk.pl>
	 <alpine.LFD.0.98.0704251323000.9964@woody.linux-foundation.org>
	 <20070425213049.GF17387@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mSIa20EZD0y/Kar652Fw"
Date: Thu, 26 Apr 2007 08:22:49 +1000
Message-Id: <1177539769.5025.82.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mSIa20EZD0y/Kar652Fw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello.

On Wed, 2007-04-25 at 23:30 +0200, Pavel Machek wrote:
> Hi!
>=20
> > > Please ask anyone who's worked with me if he's had any problem with t=
hat.
> > > If anyone say I'm unable to work with anybody else, I'd say you're ri=
ght.  Till
> > > then, I feel offended.
> >=20
> > I'll apologise (and virtually kiss your hairy feet) if you could actual=
ly=20
> > show me a single implementation that people can agree on.
> >=20
> > But until then, I claim that the suspend-to-disk people cannot work wit=
h=20
> > each other.
>=20
> It is not Rafael's fault. Actually it is quite hard to work with
> Nigel, because he implements every feature someone asks for, and wants
> to merge them all :-(. I don't expect to ever agree with Nigel on
> anything important, sorry.

I'm sorry that you feel that way, Pavel.

I can agree that I implement features that people ask for, but I think
saying "every feature someone asks for" is going a bit far (I won't ask
you to prove that). My desire is to provide Linux with hibernation
support that does more than just the bare minimum. Different people have
different usage scenarios, and this has led to me implementing more and
different features.

As to wanting to merge them all, this is true. No one wants to put time
into something only to have it left out. But I don't see why you think
this is a bad thing. Many kernel guys claim the thing follows an
evolutionary model. Well, here's software that has been developed out of
tree - evolved if you like - and which many people would consider more
mature ('evolved'?) than [u]swsusp. If evolutionary theory is to be
followed, let the fittest survive!

Nigel

--=-mSIa20EZD0y/Kar652Fw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGL9S5N0y+n1M3mo0RAmmXAKC3AiTSQi9UgLht83zGgRP0vpQZbgCg4C/W
J3zjzKvNhmZNV9n57Qmz5GY=
=u4VS
-----END PGP SIGNATURE-----

--=-mSIa20EZD0y/Kar652Fw--

