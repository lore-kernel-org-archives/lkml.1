Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbXFVWJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbXFVWJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbXFVWJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:09:31 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:43944 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753741AbXFVWJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:09:30 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v18
Date: Sat, 23 Jun 2007 01:09:07 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20070622220202.GA16872@elte.hu>
In-Reply-To: <20070622220202.GA16872@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6573956.cjJ2v2p0vI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706230109.08310.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6573956.cjJ2v2p0vI
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Ingo;

23 Haz 2007 Cts tarihinde, Ingo Molnar =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
> As usual, any sort of feedback, bugreport, fix and suggestion is more
> than welcome!

caglar@zangetsu linux-2.6 $ LC_ALL=3DC make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC      kernel/sched.o
kernel/sched.c:745:28: sched_idletask.c: No such file or directory
kernel/sched.c: In function `init_idle_bootup_task':
kernel/sched.c:4659: error: `idle_sched_class' undeclared (first use in thi=
s=20
function)
kernel/sched.c:4659: error: (Each undeclared identifier is reported only on=
ce
kernel/sched.c:4659: error: for each function it appears in.)
kernel/sched.c: In function `init_idle':
kernel/sched.c:4698: error: `idle_sched_class' undeclared (first use in thi=
s=20
function)
kernel/sched.c: In function `sched_init':
kernel/sched.c:6196: error: `idle_sched_class' undeclared (first use in thi=
s=20
function)
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart6573956.cjJ2v2p0vI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGfEiEy7E6i0LKo6YRAsiRAJ9N2k01A2I1UijGjZCrGVZIsIKBEACfdu16
La5WS67Dw7pMwiTQsIGqYT0=
=GAFn
-----END PGP SIGNATURE-----

--nextPart6573956.cjJ2v2p0vI--
