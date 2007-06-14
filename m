Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbXFNJTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbXFNJTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 05:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbXFNJTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 05:19:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:49997 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750932AbXFNJS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 05:18:59 -0400
X-Authenticated: #153925
X-Provags-ID: V01U2FsdGVkX19Mq2YFlIxM33lqB9Vcnc0HQkaR6O1OmMuPZDsmMO
	+Ji9ws07jRqR0w
From: Bernd Paysan <bernd.paysan@gmx.de>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 11:18:53 +0200
User-Agent: KMail/1.9.5
Cc: Alexandre Oliva <aoliva@redhat.com>, Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <orfy4vhyni.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614073232.GB22543@linux-sh.org>
In-Reply-To: <20070614073232.GB22543@linux-sh.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart13772364.Nr1BCSDoFa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706141118.55175.bernd.paysan@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart13772364.Nr1BCSDoFa
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 14 June 2007 09:32, Paul Mundt wrote:
> This is perhaps the part that's the most interesting. For the very small
> number of people that _do_ want to change these things (usually at the
> expense of a voided warranty, in the consumer device case), there's
> always a way to make these changes, even if you must resort to hardware
> hacking. Trying to mandate this sort of functionality in the license
> might make it easier for a few people to get their code loaded, but the
> vast majority of users have zero interest in anything like this.

I don't feel this is a very conclusive argument.

How many computer users do want to change their OS? I mean not only want to=
=20
change the OS in the sense of "apply patches released by Microsoft", but on=
=20
their own? Many typical computer users ask for help to "fix their computer"=
=20
when turning it off and on again already "fixes it". They would never ever=
=20
change the source code of their OS even if they technically could do it -=20
they are not programmers.

However, if there is the technical possibility to change the firmware of an=
=20
appliance, somebody does it, and often mere users upload these changes to=20
their own device (like the OpenWRT stuff).

Let me give one example: My parents own a DVB-T DVR. It was a cheap one, an=
d=20
it was cheap because the software is lackluster. Unfortunately it isn't=20
free. Many users of this device complain to the manufacturer about the=20
stability and quality of the software, but with no avail - there haven't=20
been any updates in the last two years. I suppose I would be able to fix=20
the problem, most other users probably wouldn't (and my parents neither).=20
But if I did fix the problem, and provided them with an updated firmware,=20
they would install it on their device.

That's the "help your neighbour" right in the GNU manifesto. It's as=20
important as the "help yourself" right, maybe even more. It was the=20
original motivation of RMS to make free software - the frustration of not=20
being able to help his neighbours. He had an NDA to help himself.

What people want is software that works. If the firmware of your microwave=
=20
or DVR works, you don't care so much if it is free or not. You only care if=
=20
it doesn't work, and you feel the urge to fix it (and turning it off and on=
=20
again doesn't fix it). That's why people complain loud about ATI drivers=20
not being open, and don't care that much about the Nvidia driver, which is=
=20
just as closed, but works.

=2D-=20
Bernd Paysan
"If you want it done right, you have to do it yourself"
http://www.jwdt.com/~paysan/

--nextPart13772364.Nr1BCSDoFa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGcQf/i4ILt2cAfDARAjXbAJ4khUlLu4GhR6tcRPHfRzw6Y0FB+QCgryBJ
wQEzyxk8kXt5nV6uzlOrmRc=
=2ml8
-----END PGP SIGNATURE-----

--nextPart13772364.Nr1BCSDoFa--
