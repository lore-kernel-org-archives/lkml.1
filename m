Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbXKMQzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbXKMQzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbXKMQz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:55:28 -0500
Received: from xenotime.net ([66.160.160.81]:48432 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755532AbXKMQz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:55:27 -0500
Date: Tue, 13 Nov 2007 08:55:14 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-Id: <20071113085514.3414aa52.rdunlap@xenotime.net>
In-Reply-To: <20071113134029.GA30978@elte.hu>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
	<20071113.033946.114918709.davem@davemloft.net>
	<20071113034916.2556edd7.akpm@linux-foundation.org>
	<20071113.035824.40509981.davem@davemloft.net>
	<20071113041259.79c9a8c5.akpm@linux-foundation.org>
	<20071113134029.GA30978@elte.hu>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 14:40:29 +0100 Ingo Molnar wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > > Do you believe that our response to bug reports is adequate?
> > > 
> > > Do you feel that making us feel and look like shit helps?
> > 
> > That doesn't answer my question.
> > 
> > See, first we need to work out whether we have a problem.  If we do 
> > this, then we can then have a think about what to do about it.
> > 
> > I tried to convince the 2006 KS attendees that we have a problem and I 
> > resoundingly failed.  People seemed to think that we're doing OK.

We were a minority.

> > But it appears that data such as this contradicts that belief.
> > 
> > This is not a minor matter.  If the kernel _is_ slowly deteriorating 
> > then this won't become readily apparent until it has been happening 
> > for a number of years.  By that stage there will be so much work to do 
> > to get us back to an acceptable level that it will take a huge effort.  
> > And it will take a long time after that for the kerel to get its 
> > reputation back.
> > 
> > So it is important that we catch deterioration *early* if it is 
> > happening.
> 

[agree with most of Ingo's moaning]

> (and this is in no way directed at the networking folks - it holds for 
> all of us. I have one main complaint about networking: the separate 
> netdev list is a bad idea - networking regressions should be discussed 
> and fixed on lkml, like most other subsystems are. Any artificial split 
> of the lk discussion space is bad.)

but here I disagree.  LKML is already too busy and noisy.
Major subsystems need their own discussion areas.

---
~Randy
