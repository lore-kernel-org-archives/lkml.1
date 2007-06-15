Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbXFOKC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbXFOKC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 06:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbXFOKCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 06:02:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:44636 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750957AbXFOKCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 06:02:17 -0400
X-Authenticated: #153925
X-Provags-ID: V01U2FsdGVkX1+en7kz8kCenyiWjKVLQyDM79p3+pUcdsXIyLstHP
	sXwGL4h9Q1GEHx
From: Bernd Paysan <bernd.paysan@gmx.de>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 12:02:11 +0200
User-Agent: KMail/1.9.5
Cc: Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org> <orzm326s3w.fsf@oliva.athome.lsd.ic.unicamp.br> <20070615052432.GC14911@thunk.org>
In-Reply-To: <20070615052432.GC14911@thunk.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1319234.GexYenK4kS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706151202.13708.bernd.paysan@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1319234.GexYenK4kS
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 15 June 2007 07:24, Theodore Tso wrote:
> On Thu, Jun 14, 2007 at 08:20:19PM -0300, Alexandre Oliva wrote:
> > So, you see, your statement above, about wanting to be able to use
> > other people's improvements, cannot be taken without qualification.
>
> No.  Linus and other Linux kernels might *want* to take other people's
> improvements, but thanks to Richard Stallman's choices for GPLv3, they
> can *not* legally take other people's improvements without violating
> the GPLv3 license.  That's not their fault, it's the fault of people
> who wrote the GPLv3 license, promulgated the GPLv3 license, and who is
> attempting to convince everyone that the GPLv3 license is the only
> valid license for Right Thinking FSF automatons to use.

Ah no, it's their fault. The GPLv2 always was clear that there will be some=
=20
future releases of the GPL, and that you should keep "upgrading" possible.

> There are plenty of things that I might *want* to do, that I am
> legally prohibited from doing.  that doesn't change the fact that I
> might want to do it.  The fact that GPLv3 is incompatible with GPLv2
> is a tragedy, in the Greek sense.

The GPLv2 tries hard to be compatible with any further versions of the GPL=
=20
as possible, by allowing people to choose which license you take, and by=20
making sure that no man in the middle can restrict this choice. If people=20
deliberately select to use "GPLv2 only", who's to blame? RMS? Come on,=20
that's bullshit. It's *Linus Torvalds* who made Linux incompatible with=20
GPLv3, nobody else - ok, Al Viro with his tagged GPLv2 files (and honestly,=
=20
I think this is just another Linus misinterpretation about the GPL, and he=
=20
really didn't do it, because he couldn't).

This thread was fun, but I think all arguments have been repeated often=20
enough. I try to give up. I suggest everyone who has some assertions about=
=20
what the GPLv2 does read it through and find the place where it says so.=20
Unfortunately, I haven't seen GPL citations from the Linus-fanboy curve,=20
only suggestions that the GPL "does not say something" which it clearly=20
does.

=2D-=20
Bernd Paysan
"If you want it done right, you have to do it yourself"
http://www.jwdt.com/~paysan/

--nextPart1319234.GexYenK4kS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD4DBQBGcmOli4ILt2cAfDARAo6GAJURZbhA6OzG484SP6tFWMSivJP2AJ4/+92X
pkfzFkJpFa3ivmU47UoDng==
=rYpC
-----END PGP SIGNATURE-----

--nextPart1319234.GexYenK4kS--
