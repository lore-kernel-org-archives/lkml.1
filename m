Return-Path: <linux-kernel-owner+w=401wt.eu-S1423298AbXD3Oi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423298AbXD3Oi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423304AbXD3Oi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:38:27 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:37497 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423298AbXD3Oi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:38:26 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v7
Date: Mon, 30 Apr 2007 17:38:13 +0300
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, Kasper Sandberg <lkml@metanurb.dk>,
       buddabrod <buddabrod@gmail.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>
References: <20070428152539.GA21601@elte.hu> <200704291537.34748.caglar@pardus.org.tr> <20070429155828.GA15089@elte.hu>
In-Reply-To: <20070429155828.GA15089@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2856035.WYq5F0JMvC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704301738.15304.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2856035.WYq5F0JMvC
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Ingo;

29 Nis 2007 Paz tarihinde, Ingo Molnar =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
> * S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr> wrote:
> > I'll report if i can find any reproducable problem, so far CFSv7 works
> > as expected :)

After complete 2 day usage, i still can't reproduce previous problems. And=
=20
even can manage to burn a dvd with k3b with one console compiles kernel,=20
other checkouts svn repos, amarok plays music, virtualbox boots another=20
distro and with 3 tab opened firefox setup :). And i must say system was=20
still usable at that time the only thing happened was a little firefox=20
slowdown but its really negligable cause with mainline firefox/whole system=
=20
really unusable if i fire a guest in virtualbox.

And lastly boot time still around ~20 sec. which is expected

Apr 29 01:39:04 (up 10.48) /sbin/mudur.py sysinit
Apr 29 01:39:13 (up 18.83) /sbin/mudur.py boot
Apr 29 01:39:18 (up 23.29) /sbin/mudur.py default
=2E..
Apr 29 15:02:54 (up 10.72) /sbin/mudur.py sysinit
Apr 29 15:03:02 (up 17.26) /sbin/mudur.py boot
Apr 29 15:03:06 (up 21.34) /sbin/mudur.py default
=2E..
Apr 30 14:21:56 (up 22.80) /sbin/mudur.py default
Apr 30 14:28:34 (up 15.67) /sbin/mudur.py sysinit
Apr 30 14:28:40 (up 21.02) /sbin/mudur.py boot
=2E..
Apr 30 14:33:26 (up 10.59) /sbin/mudur.py sysinit
Apr 30 14:33:32 (up 15.97) /sbin/mudur.py boot
Apr 30 14:33:35 (up 18.69) /sbin/mudur.py default
=2E..
Apr 30 17:02:09 (up 10.70) /sbin/mudur.py sysinit
Apr 30 17:02:16 (up 17.15) /sbin/mudur.py boot
Apr 30 17:02:19 (up 20.16) /sbin/mudur.py default

So for me, there is no problem at all :)...

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart2856035.WYq5F0JMvC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGNf9Xy7E6i0LKo6YRAmR7AJ9lEDNh6h/Q0isZQvrDUUGHQMLOOwCfdPbo
A9eEH0hDyiV5WVkX44cbfvY=
=IW4P
-----END PGP SIGNATURE-----

--nextPart2856035.WYq5F0JMvC--
