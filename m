Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbXFNIde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbXFNIde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 04:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbXFNId1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 04:33:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:60797 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751807AbXFNId1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 04:33:27 -0400
X-Authenticated: #153925
X-Provags-ID: V01U2FsdGVkX1/0AD9kQ/T0IFRnWSG7EzX6m1S51JE2qudYQC6v0n
	U2aoIVEPHQWZ8U
From: Bernd Paysan <bernd.paysan@gmx.de>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 10:33:20 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <alpine.LFD.0.98.0706131549000.14121@woody.linux-foundation.org> <or8xanl8jg.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <or8xanl8jg.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1246236.CyIZxkf0nW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706141033.22605.bernd.paysan@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1246236.CyIZxkf0nW
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 14 June 2007 01:49, Alexandre Oliva wrote:
> Oh, good, let's take this one.
>
>   if you distribute copies of such a program, [...]
>   you must give the recipients all the rights that you have
>
> So, TiVo includes a copy of Linux in its DVR.
>
> TiVo retains the right to modify that copy of Linux as it sees fit.
>
> It doesn't give the recipients the same right.
>
> Oops.
>
> Sounds like a violation of the spirit to me.
>
> Sounds like plugging this hole would retain the same spirit.

Note that Harald Welte has already managed to force Siemens to unlock=20
a "tivoized" Linux router with the GPLv2 in Germany. German contract law=20
values intention when the contract has no specific clause that deals with=20
the issue, and in German law, an accepted license is a contract.

So the fact that tivoizing Linux is against the spirit of the GPLv2 is a=20
court-proof fact, not just some speculation.

What about if your GPL program ends up in a piece of hardware (e.g. a ROM,=
=20
or an embedded ROM, or if it's some GPL code from OpenCores, as gate=20
netlist in silicon)? My interpretation is that you need a permission from=20
the author for doing that, unless there's an easy way to replace it with a=
=20
modified copy (e.g. if you put the OpenCores stuff into an FPGA, replacing=
=20
the configuration PROM would do it).

Some people have difficulties with intentions of contracts rather than=20
direct rules. That may be due to different rules in different countries. In=
=20
continental Europe, contract law usually bases on Code Napoleon, and=20
there, "good faith" is an important principle (and "good faith" means that=
=20
the intention is more important than the actual coded practices). In the=20
roman law that was used before and has survived in countries who didn't let=
=20
Napoleon in (like the UK and the USA), it's slightly different. But a=20
contract or a license still is not a program where anything that isn't said=
=20
explicitely isn't said at all.

=2D-=20
Bernd Paysan
"If you want it done right, you have to do it yourself"
http://www.jwdt.com/~paysan/

--nextPart1246236.CyIZxkf0nW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGcP1Si4ILt2cAfDARAvmsAKDVtl5xW8z9NsWFX5pvXEftawyJeQCfeHFv
uZzukcHkkmZnlIGul0BG110=
=V11W
-----END PGP SIGNATURE-----

--nextPart1246236.CyIZxkf0nW--
