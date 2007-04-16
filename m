Return-Path: <linux-kernel-owner+w=401wt.eu-S1031015AbXDPWOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031015AbXDPWOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 18:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031017AbXDPWOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 18:14:44 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:36475 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031015AbXDPWOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 18:14:43 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Date: Tue, 17 Apr 2007 01:12:26 +0300
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
References: <20070416220715.GA4071@elte.hu>
In-Reply-To: <20070416220715.GA4071@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3310601.5kDiTQG2b1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704170112.35819.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3310601.5kDiTQG2b1
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

17 Nis 2007 Sal tarihinde, Ingo Molnar =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
>  - fixed child-runs first. A /proc/sys/kernel/sched_child_runs_first
>    flag can be used to turn it on/off. (This might fix the Kaffeine bug
>    reported by S.=C3=87a=C4=9Flar Onur <)

Sorry for delayed response but i just find some free time, do you still wan=
t=20
me to test mainline + "parent-runs first" patch or will i drop that one and=
=20
test v2 which can change default behaviour?

=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart3310601.5kDiTQG2b1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGI/TTy7E6i0LKo6YRAk6RAJ9VAawNRNrJ3T/vN/PT83C6FyX60QCfUetm
Y/3dXKoPzsm5UeTpOu0XL6E=
=k22P
-----END PGP SIGNATURE-----

--nextPart3310601.5kDiTQG2b1--
