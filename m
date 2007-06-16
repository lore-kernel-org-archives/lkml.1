Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbXFPLz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbXFPLz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 07:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbXFPLzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 07:55:23 -0400
Received: from mx.laposte.net ([81.255.54.16]:26365 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbXFPLzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 07:55:22 -0400
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46063.192.54.193.51.1181897654.squirrel@rousalka.dyndns.org>
References: <46063.192.54.193.51.1181897654.squirrel@rousalka.dyndns.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-frB8/V+5/kNMqaA/p1T+"
Organization: Adresse perso
Date: Sat, 16 Jun 2007 13:55:18 +0200
Message-Id: <1181994918.4388.86.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.3 (2.11.3-4.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-frB8/V+5/kNMqaA/p1T+
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:

> and that's where the GPLv3 errs: it arbitrarily attempts to "define"=20
> some work that can _easily_ be completely separate from the GPL-ed
> work to be under the scope of "source code".

Well thanksfuly the last draft doesn't and puts keys and other such
stuff under "installation information=C2=B9". Which does not mean they may
not in fact be some sort of derived object, but I find the new language
makes the license intent much clearer. And that's the primary objective
of a license text. Yes the technical wording is important too, but a
judge does not expect the technical wording to be perfect or time-proof,
so if you focus on technicalities you get to argue on broken
technicalities later because there is not clear intent for the court to
rule on.

Some would say other parts of the last GPLv3 draft forgot this and
focused on technicalities over making the intent clear, and I wouldn't
disagree. But the DRM bit has been controversial enough its current
re-wording is quite good IMHO.

This may be anathema to many on this list but I don't actually care
about the original code author well being. I've done my share of
contributions to FLOSS projects (in code, testing, money, etc) but I've
no illusion the number of projects I've contributed to will be dwarfed
by the number of projects I'll use in my everyday-life. So to me
software licenses and the various GPL versions are primarily
user-enabling tools.

You'll note the GPL v2 doesn't particularly care about the original
software author either. Source code (and various peripheral bits Alan
cares about) must be made available to the end user, not the original
code author. It worked out this user was often the original author, or
if not said user had an incentive to retransmit the modifications to the
original author. But he can choose to have someone else work on the
source code without involving original upstream in any way, and the
license is fine with that. In fact that is what happens when there is a
rift in a project and both parties go working on their own fork.

So contrarily to what many people wrote on this list the payback for
GPL-ing some code is not access to modifications of this code but
maintaining an open technical environment. You increase the FLOSS pool
size, you increase the chance the software you use in your everyday life
is FLOSS and open to changes. Either changes you do yourself or most
often changes someone else made and you download somewhere (because
everyone is not a software god, and even those who are will never have
the time to fix themselves all the software they interact with=C2=B2). When
you get this software with or for some hardware you care about deploying
the changes on hardware you have (usually the same hardware you go the
software with)

Another way to describe this open technical environment is an
environment with no vendor lock-in.=20

For a very long time the GPLv2 served this purpose admirably.
Unfortunately nowadays the standalone general-purpose open PC is not
playing such a big part in everyday life, and we've been invaded by
embedded computers. What's worse the manufacturers of those computers
are control-freaks and making changes to the software of those computers
is no longer just a matter of having code access. Lastly there is a
definite temptation to re-make the PC on their image and add
installation controls on it too.

Therefore the GPLv2 is not sufficient to this end anymore and something
like GPLv3 is necessary. The environment changed. Being able to install
is no longer a given but something protected by law you have to
explicitely require (yes require, the industry is perfectly able to
fuck-itself up collectively for years if let alone, just look at the
HDDVD/Blue-ray debacle). What use is the source code of a mobile app to
me if the mobile industry decides to lock all the mobiles sold with a
DRM lock?

Now it could be many people on this list don't care about end users,
think only the hardware people/software people relations matter, and are
quite happy with the perspective of an environment restricted to a
technical elite. In which case I suppose a lot of users are going to
revisit their FLOSS over freeware bias in the next years, and we'll find
out the exact weight of development in the FLOSS ecosystem.

=C2=B9 Information clearly does not mean shipping users all sorts of physic=
al
tools to change the hardware, just the knowledge necessary to install
stuff

=C2=B2 Rockbox is a terrific example of Free Software logic in action in th=
e
embedded space outside technical circles, and would probably be the
first casualty of DRM extensions

--=20
Nicolas Mailhot

--=-frB8/V+5/kNMqaA/p1T+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iEYEABECAAYFAkZzz6UACgkQI2bVKDsp8g2q8gCgvzelAswZ82o10QmWttPcfPu4
or0An1EbTaF/0juB0fWTT91neMhcettN
=M3EM
-----END PGP SIGNATURE-----

--=-frB8/V+5/kNMqaA/p1T+--
