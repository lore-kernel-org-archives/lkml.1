Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbZKETmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbZKETmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758555AbZKETma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:42:30 -0500
Received: from www.tglx.de ([62.245.132.106]:42828 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758316AbZKETm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:42:29 -0500
Date: Thu, 5 Nov 2009 20:41:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>
Subject: Re: [ANNOUNCE] 2.6.31.4-rt14
In-Reply-To: <1257449624.4549.16.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911052040370.12138@localhost.localdomain>
References: <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain>  <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain>  <alpine.LFD.2.00.0908212319370.1769@localhost.localdomain>  <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain> 
 <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain>  <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain>  <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain>  <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain> 
 <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain>  <1257300790.25489.16.camel@localhost.localdomain>  <20091104083811.GA23889@pengutronix.de> <1257449624.4549.16.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-433666579-1257450085=:12138"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-433666579-1257450085=:12138
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 5 Nov 2009, Fernando Lopez-Lezcano wrote:

> On Wed, 2009-11-04 at 09:38 +0100, Uwe Kleine-König wrote:
> > On Wed, Nov 04, 2009 at 02:13:10AM +0000, Fernando Lopez-Lezcano wrote:
> > > On Wed, 2009-10-14 at 12:02 +0200, Thomas Gleixner wrote:
> > > > We are pleased to announce the next update to our new preempt-rt
> > > > series.
> > > > 
> > > >    - Forward to 2.6.31.4
> > > 
> > > Could some guru rebase to 2.6.31.5 please?
> > > I get two failed chunks in kernel/futex.c
> >
> > tip/rt/2.6.31 [1] is at v2.6.31.5-rt16 (but untagged).  You might get
> > kernel/futex.c from there.  I assume -rt16 isn't released yet as there
> > is no tag.
> > 
> > Best regards
> > Uwe
> > 
> > [1] http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=refs/heads/rt/2.6.31
> 
> Thanks! I managed to get a package done for it and I'm running it, so
> far so good. 
> 
> Do you know why it has not been officially released yet? Anything I
> should watch out for?

Simply because I did not come around as I'm swamped with my mail backlog. :(

       tglx
--8323328-433666579-1257450085=:12138--
