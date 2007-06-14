Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbXFNPoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbXFNPoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXFNPoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:44:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:33511 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751724AbXFNPoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:44:11 -0400
X-Authenticated: #153925
X-Provags-ID: V01U2FsdGVkX18Bv/Z6fEEBN9Nfw92kr8a2JjG4Gx0jfXDF33BTrL
	9/rTql9jCfZRWF
From: Bernd Paysan <bernd.paysan@gmx.de>
To: "Alan Milnes" <alan@itfoundation.org.uk>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 17:44:07 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <466A3EC6.6030706@netone.net.tr> <20070614132457.GB29423@elte.hu> <b200add30706140708p41e943dbm5d14ba52a6e0ae75@mail.gmail.com>
In-Reply-To: <b200add30706140708p41e943dbm5d14ba52a6e0ae75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7370951.SmvirUt1cq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706141744.08408.bernd.paysan@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7370951.SmvirUt1cq
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 14 June 2007 16:08, Alan Milnes wrote:
> Agreed - if you want to take my work you are welcome as long as you
> contribute back your changes.  That's the deal that GPL2 enforces and
> why it has been so successful.

That may be a side effect of the GPL, but it's actually not how the GPLv2=20
works (nor is it the intention). "Contribute back" means upstream. There's=
=20
no such provision in the GPLv2, you contribute only downstream. And there=20
are cases where you don't need to contribute at all.

E.g. the kernel hacking I'm doing at the moment: I have bought a uClinux=20
blackfin board, for testing my digital audio amplifier. For that, I took=20
one of the blackfin alsa audio drivers, and changed it so that it could=20
talk to my digital audio amplifier. I'm not distributing this software,=20
it's a complete in-house project, so I'm not obliged to contribute back. At=
=20
the moment, I'm the only person in the world who has both access to the=20
digital audio amplifier and the blackfin board, so releasing this driver in=
=20
that early stage is a rather pointless excercise.

I think this above explains fairly well the "misunderstandings" that are=20
appearing here. The GPL is not reflective (tit-for-tat), it's transient. If=
=20
there's a loop in the transient propagation, it becomes reflective through=
=20
the loop, but not by itself. This was the case in GPLv1, is the case in=20
GPLv2, and will be the case in GPLv3.

=2D-=20
Bernd Paysan
"If you want it done right, you have to do it yourself"
http://www.jwdt.com/~paysan/

--nextPart7370951.SmvirUt1cq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGcWJIi4ILt2cAfDARAnwVAKDM7sgAwDUvTdXNeP5XlCr97iKHVACgypKJ
/P6897uIBdnCP9lVOjqn0JQ=
=+aKl
-----END PGP SIGNATURE-----

--nextPart7370951.SmvirUt1cq--
