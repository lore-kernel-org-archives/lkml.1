Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbXD0SBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbXD0SBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbXD0SAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:00:53 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756985AbXD0SAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:00:07 -0400
Date: Fri, 27 Apr 2007 10:59:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: dedekind@infradead.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>
Subject: Re: [GIT-PULL] please pull UBI tree
In-Reply-To: <1177696657.7646.3.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.98.0704271059320.9964@woody.linux-foundation.org>
References: <1177677925.7539.18.camel@sauron> 
 <alpine.LFD.0.98.0704270855300.9964@woody.linux-foundation.org> 
 <1177695035.7539.36.camel@sauron>
 <1177696657.7646.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Apr 2007, Thomas Gleixner wrote:

> On Fri, 2007-04-27 at 20:30 +0300, Artem Bityutskiy wrote:
> > On Fri, 2007-04-27 at 09:00 -0700, Linus Torvalds wrote:
> > > On Fri, 27 Apr 2007, Artem Bityutskiy wrote:
> > > >
> > > > Linus, please, pull UBI tree from
> > > > git://git.infradead.org/ubi-2.6.git for-linus
> > > > 
> > > > The UBI tree has been in -mm for several releases and we would like to
> > > > see it in the mainline.
> > > 
> > > Quite frankly, I have absolutely _zero_ visibility into things like this, 
> > > so before I merge it I want ack's from various layers (preferably a 
> > > mixture of interests - are any vendors interested, is DavidW ok with this, 
> > > who is using it now and are the interfaces and designs correct etc etc?)
> > 
> > Well, IBM is using it in a large project, the involved people are in CC.
> > Thomas has 3+ customers who use it, I've added him to CC.
> 
> Right, it is deployed already in a couple of customer projects and many
> folks at the Embedded Linux Conference showed interest. 
> 
> It definitely has my ack and blessing.

Hey, I'm convinced. Pulled, pushed out.

		Linus
