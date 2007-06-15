Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbXFOItP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbXFOItP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 04:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbXFOItB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 04:49:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:54383 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751247AbXFOItA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 04:49:00 -0400
X-Authenticated: #153925
X-Provags-ID: V01U2FsdGVkX1/8R64CIRD8rxJ2Aw+eFoQkHB3TDHihiotc7BIuiv
	nMmKSuK0tzauyp
From: Bernd Paysan <bernd.paysan@gmx.de>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 10:48:56 +0200
User-Agent: KMail/1.9.5
Cc: "Alexandre Oliva" <aoliva@redhat.com>,
       "Paulo Marques" <pmarques@grupopie.com>,
       "Al Viro" <viro@ftp.linux.org.uk>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org
References: <466A3EC6.6030706@netone.net.tr> <or4plae61r.fsf@oliva.athome.lsd.ic.unicamp.br> <d120d5000706141155s4e9caceci6958ceceebad6c73@mail.gmail.com>
In-Reply-To: <d120d5000706141155s4e9caceci6958ceceebad6c73@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1894547.JqSlNEVCzG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706151048.57762.bernd.paysan@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1894547.JqSlNEVCzG
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 14 June 2007 20:55, Dmitry Torokhov wrote:
> It does not matter. GPL v2 and later can be reduced to v2 by
> recepient.

And expanded by the next recipient to GPLv2 or later, as long as the first=
=20
recipient does not make a substantial modification ("substantial" is a=20
copyright term - there is no precise definition how much must be modified,=
=20
but a line or two may not count as "substantial"). This is because you=20
receive the license from the original author, not from the man in the=20
middle.

What's still open is how you can change the conditions if you do make=20
substantial changes. My position is: If you modify work (i.e. work with=20
multiple licensors), you are not in a position to change the conditions,=20
since you have to pass on the rights you have (and that included "you may=20
use any GPL" or "you may use GPLv2 or later"). If you create work, you are=
=20
the only licensor, so you can choose (the created work needs to be=20
sufficiently independent, which e.g. a ZFS from OpenSolaris clearly would=20
be). If you combine work, you can ship the combined work only under a GPL=20
version that matches the common subset, but you cannot change the license=20
of the parts. By adding stuff under GPLv2 only, and then combining the work=
=20
to a larger work, you may achieve the effect that the larger work is then=20
GPLv2 only. You cannot achieve that people take out the GPLv2 only work,=20
and recombine it for themselves - these people then can choose other=20
license, and combine it e.g. with GPLv3 code.

If you distribute work under multiple possible license, you can also choose=
=20
which conditions you want to fulfill. But that's not imposing restrictions=
=20
to the next recipient, so the next recipient can choose again.

It's so simple: Only the author can impose restrictions, everybody else,=20
when using the GPL, has to pass on all the rights he got. If you get a=20
court verdict depends on the law system, and in an anglo-saxonian (roman)=20
system, you might get away by exploiting loopholes, but in a Code Napoleon=
=20
system, you don't, because exploiting loopholes is not "good faith".

=2D-=20
Bernd Paysan
"If you want it done right, you have to do it yourself"
http://www.jwdt.com/~paysan/

--nextPart1894547.JqSlNEVCzG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGclJ5i4ILt2cAfDARAqSLAKC4MGdtksdXecZJVHnqqVy+rMceJgCg3LcD
umUKBX933RNmYTG9/co9cIs=
=iNyp
-----END PGP SIGNATURE-----

--nextPart1894547.JqSlNEVCzG--
