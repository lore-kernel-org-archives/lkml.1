Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbXFOJa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbXFOJa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 05:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXFOJaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 05:30:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:52334 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752215AbXFOJaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 05:30:14 -0400
X-Authenticated: #153925
X-Provags-ID: V01U2FsdGVkX1+bcyYGCHqb76CaIzJVpIkn13w0ouJUtG4ArGsShl
	n8TGeU7KVV9iST
From: Bernd Paysan <bernd.paysan@gmx.de>
To: david@lang.hm
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 11:30:09 +0200
User-Agent: KMail/1.9.5
Cc: Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Fox <Kevin.Fox@pnl.gov>, Daniel Hazelton <dhazelton@enter.net>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <orr6oe9rqf.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706141643120.29630@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706141643120.29630@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3983198.dlOzFC5rsv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706151130.11184.bernd.paysan@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3983198.dlOzFC5rsv
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 15 June 2007 01:46, david@lang.hm wrote:
> if you cannot modify the software that runs on your Tivo hardware you
> haven't tried very hard.

Yes, but the GPLv2 clearly says that you don't have to try very hard. The=20
preferred form of modification has to be distributed. I can run a=20
decompiler or disassembler on a program, and I can even modify it in place=
=20
with a hex editor (I have even modified programs in embedded ROMs by using=
=20
focussed ion beam, so I know you can modify every program if you try hard=20
enough). It's certainly possible to crack Tivo's firmware to accept my own=
=20
signature, but it's *not* the preferred form of modification, the source=20
code and Tivo's key for the signature.

Since Tivo's firmware only accepts a signed kernel, the combination of=20
kernel+signature is the binary they ship. The kernel itself is useless, the=
=20
signature as well. Therefore, you can imply that Tivo's key is part of=20
the "other stuff" the GPLv2 mentions, because you need it to recreate the=20
same code as Tivo did and shipped (compilers insert timestamps and such),=20
and to modify that code. The source code is just a mean, the thing they=20
shipped is the end (the binary), and they have to comply with the GPL for=20
that binary - which by all means of practical understanding includes the=20
signature.

"You can imply" means: It depends on court and legal system. I'm quite=20
confident that in Germany, the legal system might favor the "GPLv2 does not=
=20
allow tivoization" point of view, and in the USA, the legal sysem might do=
=20
the opposite.

=2D-=20
Bernd Paysan
"If you want it done right, you have to do it yourself"
http://www.jwdt.com/~paysan/

--nextPart3983198.dlOzFC5rsv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGclwji4ILt2cAfDARAo9fAJ9tR2d3QdD6s1AAP8/QucN11WgZNwCgwhzg
EQ2ybRkkjDWDt6S9+fJ4AbQ=
=x+4J
-----END PGP SIGNATURE-----

--nextPart3983198.dlOzFC5rsv--
