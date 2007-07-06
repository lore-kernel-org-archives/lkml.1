Return-Path: <linux-kernel-owner+w=401wt.eu-S1762377AbXGFBO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762377AbXGFBO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 21:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760034AbXGFBOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 21:14:19 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:51287 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758293AbXGFBOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 21:14:18 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
Date: Thu, 5 Jul 2007 21:16:15 -0400
User-Agent: KMail/1.9.7
Cc: 7eggert@gmx.de, Karel Zak <kzak@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nix <nix@esperi.org.uk>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>
References: <OF957A5E7F.B63DEC46-ON8825730F.0082A484-88257310.0002C205@us.ibm.com>
In-Reply-To: <OF957A5E7F.B63DEC46-ON8825730F.0082A484-88257310.0002C205@us.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4791431.GoP8oMTnh2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707052116.16681.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4791431.GoP8oMTnh2
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 05 July 2007, Bryan Henderson wrote:
> >i dont see how blaming autotools for other people's misuse is relevant
>
> Here's how other people's misuse of the tool can be relevant to the choice
> of the tool: some tools are easier to use right than others.  Probably the
> easiest thing to use right is the system you designed and built yourself.
> I've considered distributing code with an Autotools-based build system
> before and determined quickly that I am not up to that challenge.  (The
> bigger part of the challenge isn't writing the original input files; it's
> debugging when a user says his build doesn't work).  But as far as I know,
> my hand-rolled build system is used correctly by me.

which brings us back to the package maintainer maintains the autotool sourc=
e=20
files, not joe blow user.  if there's trouble with the build system, then t=
he=20
maintainers (who are knowledgeable in autotools) are in a pretty easy=20
position to fix/address it.  as you've stated, hand rolled build systems wo=
rk=20
great for the guy rolling it, but beyond that all bets are off.  util-linux=
=20
had a hand rolled build system that fell apart in many places.  the=20
maintainers of util-linux have well versed autotool people at their disposa=
l,=20
so i really dont see this as being worrisome.

> > > checks the width of integers on i386 for projects not caring about th=
at
> > > and fails to find installed libraries without telling how it was
> > > supposed to find them or how to make it find that library.
> >
> > no idea what this rant is about.
>
> The second part sounds like my number 1 complaint as a user of
> Autotools-based packages: 'configure' often can't find my libraries.  I
> know exactly where they are, and even what compiler and linker options are
> needed to use them, but it often takes a half hour of tracing 'configure'
> or generated make files to figure out how to force the build to understand
> the same thing.  And that's with lots of experience.  The first five times
> it was much more frustrating.

the large majority of time, i find this to be trivial: read config.log.  bu=
t=20
this comes with familiarity with the tool and autotools is sitting by far t=
he=20
best right now.  if you're having trouble with the package in question, jus=
t=20
ask on the mailing list and post your config.log; i'm sure you'd get someon=
e=20
to readily point out the answer.
=2Dmike

--nextPart4791431.GoP8oMTnh2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARo2X4EFjO5/oN/WBAQKpLRAA0LG/pEqFlP/y67ib7mtl5kr7sYzH7/Jz
V/FXLoEO2fP243xUWU+jXw2bG6aEgH/jJ0zvsVUwydlJ9ytnlhQ89nSCatRWu8Wq
+lK2xawP3SXZy041Pr9lt5ADXyw9M+LfiQW4v7ljNJzdF7ah8jKnMdWQjj0oUzHI
lK0tQUj4DISLsJStzQk89bAn7E4Ci7md5p6x+/sOk041AzVaV/JvxLc0Ipvr8AvF
ca2PchbZcXKyPTbn74qCm7+kp6nTF1mJwju+AnCJGTzkpCnILg2pJGMcZX4i2yH9
xgeY+Wb0kcgY4Q22Y6i8uu3ajzCW2IJqQvnutsGrIjd5i472KKG4mMIXUYsEkr/7
OeWVi9TKMq6vLM+G37r7fAa7lmEzejZ+rvT5fFTPvzE8p9W0vL/Bq8HN7Ix52LBQ
ExdIlFKmcOJ0KxOXi1eIU5cNOz8dR8ZWw5XQrzyqCQXecNzbk68gwq6dFmHmJqPT
w4niuL9chxsgvj1RxR3smPI4E4+k28jt2iCGsm34VUPCjLGuMBVDFFeO7zQWrs45
j9Lfctc2CuvH/uKT4sPAUloul884K6D117NoRHSWmpANDK7Rg+4EmHGySjxcJrRw
Ib/jU+5Qunhb1bTYFgIxBN4i7k3kovVKhkNeeO/B9nuxcAb2dM+aPr0ABepj6pN7
K6eDiq2yUcw=
=9gWN
-----END PGP SIGNATURE-----

--nextPart4791431.GoP8oMTnh2--
