Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbXFNIXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbXFNIXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 04:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXFNIXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 04:23:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:33766 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752195AbXFNIXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 04:23:24 -0400
X-Authenticated: #153925
X-Provags-ID: V01U2FsdGVkX19HhfUeoTJH+WmjcFXbJ/8P018sDAYcefUeWrkKam
	nK/qCpaHm/oZAg
From: Bernd Paysan <bernd.paysan@gmx.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 10:23:20 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <466A3EC6.6030706@netone.net.tr> <200706131624.37211.bernd.paysan@gmx.de> <m3hcpb7gt2.fsf@maximus.localdomain>
In-Reply-To: <m3hcpb7gt2.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2001903.7aYMTvu7mX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706141023.21624.bernd.paysan@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2001903.7aYMTvu7mX
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 13 June 2007 22:14, Krzysztof Halasa wrote:
> It seems so.
>
> > But it has this upgrade option, and one possible interpretation of
>
>       ^^
>
> > Linus' comment is "no, it doesn't have this update option".
>
> It? What "it"?
> I don't get it. If you say the licence is v2 only, then how can it have
> options?

By section 9. The license is v2, and basically allows to update the=20
license - and it makes this a choice of the user (who also has rights to=20
change stuff and redistribute it).

> > If I use GPL as license, I'm under "GPL regime", i.e. the terms of the
> > GPL apply.
>
> First, the local and international laws apply. It's not like selling your
> soul to the devil.

Contract law means that first and foremost the contract itself defines the=
=20
rules, and only if it is not or contradicts the law, the law jumps in. The=
=20
GPL is not really a contract, it's a license, but the law is not much=20
different here, especially once you accept the GPL. If you put your code=20
under GPL, the text in the GPL is the deal. The law is only the framework=20
under which the deal works.

If you accept the M$ EULA, international law still applies, yet you are=20
selling your soul to the devil (because the EULA sais so).

> > Now, I may rewrite those few "GPLv2 only" files, and
> > then I have a GPLv2-or later compatible linux-some.version-bp kernel.
>
> Sure, you can rewrite all non "GPLv2 or later" code and have v3 Linux.
> The problem is you think only "few" files are v2.

Because only few files say so, and they must say what they mean, because GP=
L=20
is rather clear that if you put a file which doesn't say which version=20
applies under GPL, it's "any GPL". Why is it so difficult to grok section 9=
=20
of the current GPLv2, which people claim is well understood?

A number of kernel hacker deliberately want their work under GPLv2 only=20
(like Al Viro), and they are fully entitled to do that - but they must=20
announce it in a propper place (not lkml or lwn.org), and a comment in=20
COPYING signed by Linus Torvalds doesn't seem to be propper to me,=20
especially when the GPLv2 gives a procedure how to do it (look for the=20
appendix: "How to Apply These Terms to Your New Programs").

There are good reasons to follow the advice there, and those who did follow=
=20
the advice in the Linux kernel in the vast majority said "GPLv2 or later".=
=20
Verbatim copy without understanding? Or is it rather that the other people=
=20
who didn't follow the advice didn't read the GPL, and therefore understand=
=20
it even less ;-)?

=2D-=20
Bernd Paysan
"If you want it done right, you have to do it yourself"
http://www.jwdt.com/~paysan/

--nextPart2001903.7aYMTvu7mX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGcPr5i4ILt2cAfDARAiVVAJ93naIgIarY0dSEj7axqP8wahrOFgCgo4ex
qW6G4bK4z670aC8VyUrVex8=
=XFKd
-----END PGP SIGNATURE-----

--nextPart2001903.7aYMTvu7mX--
