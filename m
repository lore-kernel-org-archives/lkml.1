Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab0BXPKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 10:10:54 -0500
Received: from www.tglx.de ([62.245.132.106]:35339 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab0BXPKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 10:10:53 -0500
Date: Wed, 24 Feb 2010 16:09:40 +0100 (CET)
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
In-Reply-To: <49b7c2351002240643s1aebe384wee5ee7951e62640e@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1002241609050.4245@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain>  <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain>  <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain> 
 <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain>  <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain>  <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain>  <520f0cf11002220311l2a0caa83lf3ae2817b78501b6@mail.gmail.com> 
 <49b7c2351002231708r279049f9hcc9cc6ff205a47fb@mail.gmail.com>  <25891f3e1002231719u4d38ed52w99c66ac669c3d965@mail.gmail.com> <49b7c2351002240643s1aebe384wee5ee7951e62640e@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Feb 2010, GeunSik Lim wrote:

> On Wed, Feb 24, 2010 at 10:19 AM, Dhaval Giani
> <dhaval.lists@thegianis.in> wrote:
> > Hi GeunSik,
> > Try the latest tip/rt/head and it should now be fixed up!
> > Thanks,
> > --
> > Dhaval
> Thank you for your opinion to test with recent version.
> So, I tried linux-2.6.33-rc8-rt1 based on tip/rt/head as you explained.
> 
> Git development branch:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/head

What's the sha1 of the head commit ?
 
Thanks,

	tglx
