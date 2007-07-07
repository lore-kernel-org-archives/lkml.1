Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbXGGJQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbXGGJQY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 05:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbXGGJQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 05:16:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50090 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbXGGJQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 05:16:14 -0400
Date: Sat, 7 Jul 2007 11:15:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Rui Nuno Capela <rncbc@rncbc.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "jcaceres@ccrma.Stanford.EDU" <jcaceres@ccrma.Stanford.EDU>,
       Carsten Emde <carsten.emde@osadl.org>
Subject: Re: v2.6.21.5-rt19
Message-ID: <20070707091527.GA21234@elte.hu>
References: <1183582155.3291.160.camel@chaos> <9609.194.65.103.1.1183731007.squirrel@www.rncbc.org> <1183758545.20747.34.camel@cmn3.stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183758545.20747.34.camel@cmn3.stanford.edu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:

> > Althought I'm still with my fingers crossed, I can tell the good 
> > news are that 2.6.21.5-rt19 (and -rt20) does behave far better now 
> > on the very same box.
> 
> Yes, it works much better indeed...
> 
> Ingo: is there a place where I can read about the changes in different 
> rtxx releases? What is new/better/fixed in rt20? (I see scheduler 
> stuff in a diff from rt19 to rt20 but I don't really know what it 
> means).

rt19 -> rt20 was a pure CFS update - from v18 to v19-almost-final.

	Ingo
