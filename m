Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbXDOWsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbXDOWsw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 18:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbXDOWsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 18:48:52 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:55312 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754032AbXDOWsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 18:48:51 -0400
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Mon, 16 Apr 2007 01:49:35 +0300
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu>
In-Reply-To: <20070413202100.GA9957@elte.hu>
X-Face: 9Va_@~iRiB"*X1O@K#(=?utf-8?q?thBxy=236XXkD87I=3DG=7E=23=26tFA=26=24mM+4oHIQZGdgCx9=23IZ=7ByL-?=
 =?utf-8?q?rk8CY=0A=09u=3B=7DX=7D?=,+R%vB]|/kKH:-<%Mym?njPCL%'gcIX.J$I}9+{Q|vvl0&c+>WFNbuN,>)
 =?utf-8?q?Of=3AUJq0=0A=09=7DL9+?="}tE:hB<t]y=^%m/R6z.OA8}$@VZ6N?m?h4^,GBNW&xS]9'I?;1OEohho"yF>
 =?utf-8?q?s36=7EN=0A=09=5CE0=60?=@O~`!C>JQkL|pqY{]A7Ow0PD$;BJ9^%!$[hV?(lrTA\rJk\rxnz>oW&W,
 =?utf-8?q?=3DE3obyZfC=0A=09=5EC=7BbqWCY?=
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1608857.Gt8iZK2SVB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704160149.42914.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1608857.Gt8iZK2SVB
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
On Friday 13 April 2007 23:21:00 Ingo Molnar wrote:
> [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler
> [CFS]
>
> i'm pleased to announce the first release of the "Modular Scheduler Core
> and Completely Fair Scheduler [CFS]" patchset:
>
>    http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch

Tested this on top of Linus' GIT tree but the system gets very unresponsive=
=20
during high disk i/o using ext3 as filesystem but even writing a 300mb file=
=20
to a usb disk (iPod actually) has the same affect.

Regards,
ismail

--nextPart1608857.Gt8iZK2SVB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGIqwGGp0leluI9UwRAngbAJ44gEQKpBBj8/pMmgVs+I3FODSiVACfS9ad
cko3YXznLNQ84EPiac1YGuk=
=+5lG
-----END PGP SIGNATURE-----

--nextPart1608857.Gt8iZK2SVB--
