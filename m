Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbXEDNFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbXEDNFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbXEDNFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:05:20 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:40771 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755127AbXEDNFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:05:18 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v7
Date: Fri, 4 May 2007 15:05:12 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       Kasper Sandberg <lkml@metanurb.dk>, buddabrod <buddabrod@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
References: <20070428152539.GA21601@elte.hu> <200704291928.52575.prakash@punnoor.de>
In-Reply-To: <200704291928.52575.prakash@punnoor.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart28743504.ruubTzPIat";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705041505.13513.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart28743504.ruubTzPIat
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Sonntag 29 April 2007 schrieb Prakash Punnoor:
> Am Samstag 28 April 2007 schrieb Ingo Molnar:
> > i'm pleased to announce release -v7 of the CFS scheduler patchset. (The
> > main goal of CFS is to implement "desktop scheduling" with as high
> > quality as technically possible.)
> >
> > The CFS patch against v2.6.21 (or against v2.6.20.8) can be downloaded
> > from the usual place:
>
> I made a quick test with the ac3 encoder aften, I tested against rsdl 0.36
> (I think it was). Time was slightly worse: >5.9 secs (with two threads on
> Athlon64 X2 x86_64). mainline gives me 5.4sec. rsdl took 5.8 sec.
>
> I haven't testes earlier cfs nor later sd. Seems scheduler gets optimized
> more for single core than smp?
>
> http://aften.sourceforge.net/

Just as an update: Ingo managed to fix this issue in v9. Nice work!

Cheers,
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart28743504.ruubTzPIat
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGOy+JxU2n/+9+t5gRAkufAKC51o8G95yHZClFL1jBWuc/pyWG1QCfRiZ+
q1v9gsGy51Hm4hkOaerOeDY=
=qXph
-----END PGP SIGNATURE-----

--nextPart28743504.ruubTzPIat--
