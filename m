Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbXFNL2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbXFNL2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 07:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXFNL2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 07:28:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:43367 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751302AbXFNL2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 07:28:05 -0400
X-Authenticated: #153925
X-Provags-ID: V01U2FsdGVkX19WMxwOiaxWO3B4NNv7L4np7Db/vHVql1t6ptw64Q
	zyARaIGVNnQXq1
From: Bernd Paysan <bernd.paysan@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 13:27:59 +0200
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Hazelton <dhazelton@enter.net>,
       Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <20070614112329.3645c397@the-village.bc.nu> <20070614103846.GA7902@elte.hu>
In-Reply-To: <20070614103846.GA7902@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1487594.etLaccyozl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706141328.00798.bernd.paysan@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1487594.etLaccyozl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 14 June 2007 12:38, Ingo Molnar wrote:
> that's fine, but the fundamental question is: where is the moral
> boundary of the power that the copyright license gives? The FSF seems to
> believe "nowhere, anything that copyright law allows us to achieve our
> goals is a fair game" - and the GPLv3 shows that belief. I dont
> subscribe to that view. I think the proper limit is the boundary where
> the limit of the software is - because that's the only sane and globally
> workable way to stop the power-hungry. I.e. the information we produce
> is covered by the rules of the GPL. It might be used in ways
> inconvenient to us, it might be put on hardware we dont like (be that a
> Tivo, a landmine or an abortion instrument) but that does not change the
> fundamental fact: it's outside the _moral scope_ of our power.

Where is the boundary between hard- and software? I'm employed as hardware=
=20
designer, and for this purpose, I write programs in a hardware description=
=20
language, which can be converted into hardware through a synthesis=20
software. I write firmware, which is assembled into binary and gets placed=
=20
on on-chip memory (ROM or NVM). I've even studied computer science, and=20
electric engineering was just a side-course. I know how transistors work,=20
and how gates are implemented in terms of transistors, but in essense, it's=
=20
not that relevant unless you want to do analog circuits. Usually, during=20
the development phase, we put the Verilog into an FPGA, where the=20
configuration file still is obviously "software" in any sense it can be.=20
I've even released descriptions of some parts of the work I do under GPL=20
for people to put it into their own FPGAs.

There is no boundary between hard- and software in the sense of that=20
hardware is something fundamentally different. Hardware is just another way=
=20
to implement programs, and it uses other languages (but SystemC even looks=
=20
quite close to C). If there is a boundary, it's way below the distinction=20
between a Tivo and a PC, because these two basically consist of a=20
processor, some RAM, some flash, a harddisk, and a video driver.

What's true: We don't have the moral power to define *where* the software=20
goes, but we have the moral power to define *how* users can change the=20
software when they own the hardware (the physical representation).

=2D-=20
Bernd Paysan
"If you want it done right, you have to do it yourself"
http://www.jwdt.com/~paysan/

--nextPart1487594.etLaccyozl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGcSZAi4ILt2cAfDARApiOAKDZ45gF1KrY81Sf5cocLaFNniFhkQCglOTK
8vtOGFF7EA/LLoU2E0xxRDc=
=plRK
-----END PGP SIGNATURE-----

--nextPart1487594.etLaccyozl--
