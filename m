Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbXD1Xmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbXD1Xmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbXD1Xmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:42:53 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:44976 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754410AbXD1Xmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 19:42:51 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v7
Date: Sun, 29 Apr 2007 02:42:39 +0300
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
References: <20070428152539.GA21601@elte.hu> <200704282220.17689.caglar@pardus.org.tr> <20070428192446.GA18822@elte.hu>
In-Reply-To: <20070428192446.GA18822@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2963150.HxmyGSsPr3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704290242.43741.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2963150.HxmyGSsPr3
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

28 Nis 2007 Cts tarihinde, Ingo Molnar =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
> * S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr> wrote:
> > If you want some more output/info etc. please just say, i have both v6
> > and v7 available.
>
> could you try the auto-renice patch ontop of -v7:
>
>   http://people.redhat.com/mingo/cfs-scheduler/sched-cfs-auto-renice.patch
>
> does this make it behave like -v6?

Ingo, please ignore my first report until i found a proper way to reproduce=
=20
the slowness cause currently CFS-v7, CFS-v7 + "renice patch", CFS-v7 + reni=
ce=20
+ your private mail suggestions and CFS-v6 + "PI support for futexes patch"=
=20
seems works equally (which is a good thing so X renicing seems really not=20
needed, and there were no regression instead of my daydreams) or im too tir=
ed=20
to understand the differences.

=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart2963150.HxmyGSsPr3
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGM9vzy7E6i0LKo6YRAnCrAJ4yYHLaBRYT+FO352MPR6/yTdlViwCePlid
z4P3GI0swdQFqb1SAGpVRmM=
=7/mL
-----END PGP SIGNATURE-----

--nextPart2963150.HxmyGSsPr3--
