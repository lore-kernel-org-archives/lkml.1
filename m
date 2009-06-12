Return-Path: <linux-kernel-owner+w=401wt.eu-S933102AbZFLISV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbZFLISV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759765AbZFLISI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:18:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59824 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474AbZFLISF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:18:05 -0400
Date: Fri, 12 Jun 2009 18:18:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: manual merge of the asm-generic tree with Linus'
 tree
Message-Id: <20090612181802.b7bf4fd6.sfr@canb.auug.org.au>
In-Reply-To: <200906121005.33490.arnd@arndb.de>
References: <20090612164914.e03160af.sfr@canb.auug.org.au>
	<200906121005.33490.arnd@arndb.de>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Jun_2009_18_18_02_+1000_=ROKbhIFDcPv2H=A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Jun_2009_18_18_02_+1000_=ROKbhIFDcPv2H=A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Fri, 12 Jun 2009 10:05:32 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Friday 12 June 2009, Stephen Rothwell wrote:
> > Today's linux-next merge of the asm-generic tree got a conflict in
> > include/asm-generic/atomic.h between commit
> > 53e111a730ea8b002d57dd226098c12789993329 ("x86: Fix atomic_long_xchg() =
on
> > 64bit") from Linus' tree and commit
> > 72099ed2719fc5829bd79c6ca9d1783ed026eb37 ("asm-generic: rename atomic.h
> > to atomic-long.h") from the asm-generic tree.
> >=20
> > I applied the fix from the former patch to atomic-long.h
>=20
> I pulled Linus' tree into the asm-generic tree now and fixed the two conf=
licts
> in the same way you did. I thought about doing a rebase on his tree inste=
ad,
> but wasn't sure what works better.

I think what works better is what you are most comfortable with.  Your
way works fine for me.  Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Jun_2009_18_18_02_+1000_=ROKbhIFDcPv2H=A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoyDzoACgkQjjKRsyhoI8ykmACfU1y0Uk4fUN+wuyr3eNiVZR+1
WwQAoKNCx6x/w0kkUAeknvF70jTWy1Ue
=0r3V
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jun_2009_18_18_02_+1000_=ROKbhIFDcPv2H=A--
