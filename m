Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbZKETfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbZKETfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758682AbZKETfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:35:04 -0500
Received: from smtp3.Stanford.EDU ([171.67.219.83]:40387 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758445AbZKETfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:35:02 -0500
Subject: Re: [ANNOUNCE] 2.6.31.4-rt14
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <20091104083811.GA23889@pengutronix.de>
References: <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain>
	 <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain>
	 <alpine.LFD.2.00.0908212319370.1769@localhost.localdomain>
	 <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain>
	 <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain>
	 <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain>
	 <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain>
	 <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain>
	 <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain>
	 <1257300790.25489.16.camel@localhost.localdomain>
	 <20091104083811.GA23889@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Nov 2009 11:33:44 -0800
Message-Id: <1257449624.4549.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 09:38 +0100, Uwe Kleine-König wrote:
> On Wed, Nov 04, 2009 at 02:13:10AM +0000, Fernando Lopez-Lezcano wrote:
> > On Wed, 2009-10-14 at 12:02 +0200, Thomas Gleixner wrote:
> > > We are pleased to announce the next update to our new preempt-rt
> > > series.
> > > 
> > >    - Forward to 2.6.31.4
> > 
> > Could some guru rebase to 2.6.31.5 please?
> > I get two failed chunks in kernel/futex.c
>
> tip/rt/2.6.31 [1] is at v2.6.31.5-rt16 (but untagged).  You might get
> kernel/futex.c from there.  I assume -rt16 isn't released yet as there
> is no tag.
> 
> Best regards
> Uwe
> 
> [1] http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=refs/heads/rt/2.6.31

Thanks! I managed to get a package done for it and I'm running it, so
far so good. 

Do you know why it has not been officially released yet? Anything I
should watch out for?

-- Fernando


