Return-Path: <linux-kernel-owner+w=401wt.eu-S965475AbXDVIac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965475AbXDVIac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 04:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932339AbXDVIac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 04:30:32 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:51519 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932255AbXDVIab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 04:30:31 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, v4
Date: Sun, 22 Apr 2007 10:30:07 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
References: <20070420140457.GA14017@elte.hu>
In-Reply-To: <20070420140457.GA14017@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1690017.Q7bN9SWmJE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704221030.24168.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1177230631;15cea697;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1690017.Q7bN9SWmJE
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> i'm pleased to announce release -v4 of the CFS patchset. The patch=20
> against v2.6.21-rc7 can be downloaded from:
>=20
>     http://redhat.com/~mingo/cfs-scheduler/

I can't get 2.6.21-rc7-CFS-v4 to boot. Immediately after selecting
this kernel I see a very fast scrolling (loop?) sequence of addrs
which I don't know how to stop to write them down. They don't appear
in any kernel log either. However I see two Tux at the top of the
screen.

I'm using the very same .config I also use with 2.6.21-rc7-sd0.x

What could be wrong and how could I track that down ?

=46WIW this also happened with 2.6.21-rc7-CFS-v3 and thus for
2.6.21-rc7-CFS-v4 I did a pristine extract of 2.6.20.tar.bz2 and
applied all patches freshly.

System is a Dell XPS M1710, Intel Core2 T7600 2.33, 4GB

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart1690017.Q7bN9SWmJE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGKx0fUYYhyuxDQc4RAuGgAJ9u0bnzBfzblS0EI12MAAebhZFO8gCeKPCY
kbgU/oEnKCIbJT9WIhDoecU=
=R64E
-----END PGP SIGNATURE-----

--nextPart1690017.Q7bN9SWmJE--
