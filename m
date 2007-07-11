Return-Path: <linux-kernel-owner+w=401wt.eu-S932655AbXGKVro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655AbXGKVro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765968AbXGKVr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:47:26 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42920 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765763AbXGKVrZ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:47:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
In-Reply-To: Your message of "Wed, 11 Jul 2007 23:16:38 +0200."
             <20070711211638.GE18767@one.firstfloor.org>
From: Valdis.Kletnieks@vt.edu
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
            <20070711211638.GE18767@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1184190381_3416P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Jul 2007 17:46:21 -0400
Message-ID: <28188.1184190381@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1184190381_3416P
Content-Type: text/plain; charset=us-ascii

On Wed, 11 Jul 2007 23:16:38 +0200, Andi Kleen said:

(Note - I'm just a usually-confused crash test dummy here...)

> Well I spent a lot of time making the x86-64 timing code work
> well on a variety of machines; working around a wide variety
> of hardware and platform bugs. I obviously don't agree on your description
> of its maintenance state. 

I'm seeing a bit of a disconnect here.  If you spent all that time making it
work, how come the guys who developed the patch are saying you didn't provide
any feedback about the patchset?

> > What contribution do we have from you instead? A week before the .23 
> 
> I told him my objections privately earlier. Basically i would
> like to see an actually debuggable step-by-step change, not a rip everything 
> out.

Odd, I looked at the patchset fairly closely a number of times, as I was
hand-retrofitting the -rc[1-4] versions onto -rc[1-4]-mm kernels, and it looked
to *me* like it was a nice set of 20 or so step-by-step changes (bisectable
and everything - I got to do that once trying to figure out which one I botched).
Was there something in there that I missed?


--==_Exmh_1184190381_3416P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGlU+tcC3lWbTT17ARAp0VAJ925Sy7/Bn2NxnmBREovYK4R8eRuACg52/Y
ipx52ACUrA1h3gCUzaafFAc=
=ghyu
-----END PGP SIGNATURE-----

--==_Exmh_1184190381_3416P--
