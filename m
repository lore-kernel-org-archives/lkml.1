Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbXDXQ62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbXDXQ62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 12:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbXDXQ62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 12:58:28 -0400
Received: from lugor.de ([212.112.242.222]:37654 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753631AbXDXQ61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 12:58:27 -0400
From: Christian Hesse <mail@earthworm.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v5
Date: Tue, 24 Apr 2007 18:54:43 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Ulrich Drepper <drepper@redhat.com>
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu>
In-Reply-To: <20070423011229.GA20367@elte.hu>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3469380.Aci1EtfbKl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704241854.47269.mail@earthworm.de>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.0 (solar.vpn.lugor.de [10.5.1.1]); Tue, 24 Apr 2007 18:54:56 +0200 (CEST)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3469380.Aci1EtfbKl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 23 April 2007, Ingo Molnar wrote:
> i'm pleased to announce release -v5 of the CFS scheduler patchset.

Hi Ingo,

I just noticed that with cfs all processes (except some kernel threads) run=
 on=20
cpu 0. I don't think this is expected cpu affinity for an smp system? I=20
remember about half of the processes running on each core with mainline.
=2D-=20
Regards,
Chris

--nextPart3469380.Aci1EtfbKl
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGLjZXlZfG2c8gdSURAvd0AJkBM07uyK0OFfQcZn/TVVagwl2D3gCgnhEu
nrX+qeEdpb/13zDMbdV76nQ=
=uh6U
-----END PGP SIGNATURE-----

--nextPart3469380.Aci1EtfbKl--
