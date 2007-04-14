Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbXDNPMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbXDNPMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 11:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbXDNPMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 11:12:07 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:36354 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752324AbXDNPMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 11:12:06 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Sat, 14 Apr 2007 18:09:55 +0300
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu>
In-Reply-To: <20070413202100.GA9957@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1203177.yquOgsxTbv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704141809.58737.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1203177.yquOgsxTbv
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

13 Nis 2007 Cum tarihinde, Ingo Molnar =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
> [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler
> [CFS]
>
> i'm pleased to announce the first release of the "Modular Scheduler Core
> and Completely Fair Scheduler [CFS]" patchset:

Currently im using Linus's current git + your extra patches + CFS for a whi=
le.=20
Kaffeine constantly freezes (and uses %80+ CPU time) [1] if i seek=20
forward/backward while its playing a video with some workload (checking out=
=20
SVN repositories, compiling something). Stopping other process didn't help=
=20
kaffeine so it stays freezed stated until i kill it.

I'm not sure whether its a xine-lib or kaffeine bug (cause mplayer didn't h=
ave=20
that problem) but i can't reproduce this with mainline or mainline + sd-0.3=
9.

[1] http://cekirdek.pardus.org.tr/~caglar/psaux
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1203177.yquOgsxTbv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGIO7Gy7E6i0LKo6YRAj8tAKC9c0dGwT0/is4cD3NO7WiXHV/LAgCfV/KP
c5OERc6JkPFuWCtO+0Uuw4w=
=hvbz
-----END PGP SIGNATURE-----

--nextPart1203177.yquOgsxTbv--
