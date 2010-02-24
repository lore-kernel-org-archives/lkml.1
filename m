Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab0BXRxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 12:53:17 -0500
Received: from www.tglx.de ([62.245.132.106]:45558 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757025Ab0BXRxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 12:53:15 -0500
Date: Wed, 24 Feb 2010 18:52:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: GeunSik Lim <leemgs1@gmail.com>
cc: Dhaval Giani <dhaval.lists@thegianis.in>, John Kacur <jkacur@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [ANNOUNCE] 2.6.33-rc8-rt1
In-Reply-To: <49b7c2351002240852u3b2e7a56g1b0140d37a02c81f@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1002241849490.4245@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain>  <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain>  <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain> 
 <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain>  <520f0cf11002220311l2a0caa83lf3ae2817b78501b6@mail.gmail.com>  <49b7c2351002231708r279049f9hcc9cc6ff205a47fb@mail.gmail.com>  <25891f3e1002231719u4d38ed52w99c66ac669c3d965@mail.gmail.com> 
 <49b7c2351002240643s1aebe384wee5ee7951e62640e@mail.gmail.com>  <alpine.LFD.2.00.1002241609050.4245@localhost.localdomain> <49b7c2351002240852u3b2e7a56g1b0140d37a02c81f@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1424811527-1267033938=:4245"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1424811527-1267033938=:4245
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 25 Feb 2010, GeunSik Lim wrote:
> On Thu, Feb 25, 2010 at 12:09 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> So, I tried linux-2.6.33-rc8-rt1 based on tip/rt/head as you explained.
> >>
> >> Git development branch:
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/head
> > What's the sha1 of the head commit ?
> > Thanks,
> >        tglx
> >
> Dear Thoomas,
> 
> Below was the  recent commit number  when I typed "git clone" command.
> 
> commit ed0799048b4a38ffb6e33755ba5e6b5dfa9a24d2
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Sun Feb 21 23:14:28 2010 +0100
> 
>     v2.6.33-rt1

So you cloned the rt/2.6.33 branch of tip. rt/head does not have
release numbers. The version in the Makefile is simply
2.6.33-rc8-rt. rt/head is where development happens. When stuff seems
stable I update rt/2.6.xx and bump the -rt version and tag it.

Thanks,

	tglx
--8323328-1424811527-1267033938=:4245--
