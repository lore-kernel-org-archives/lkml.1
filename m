Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbXD0RbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbXD0RbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbXD0RbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:31:09 -0400
Received: from smtp.nokia.com ([131.228.20.173]:29966 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbXD0RbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:31:07 -0400
Subject: Re: [GIT-PULL] please pull UBI tree
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.LFD.0.98.0704270855300.9964@woody.linux-foundation.org>
References: <1177677925.7539.18.camel@sauron>
	 <alpine.LFD.0.98.0704270855300.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 27 Apr 2007 20:30:35 +0300
Message-Id: <1177695035.7539.36.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 27 Apr 2007 17:30:36.0040 (UTC) FILETIME=[C4036080:01C788F1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 09:00 -0700, Linus Torvalds wrote:
> On Fri, 27 Apr 2007, Artem Bityutskiy wrote:
> >
> > Linus, please, pull UBI tree from
> > git://git.infradead.org/ubi-2.6.git for-linus
> > 
> > The UBI tree has been in -mm for several releases and we would like to
> > see it in the mainline.
> 
> Quite frankly, I have absolutely _zero_ visibility into things like this, 
> so before I merge it I want ack's from various layers (preferably a 
> mixture of interests - are any vendors interested, is DavidW ok with this, 
> who is using it now and are the interfaces and designs correct etc etc?)

Well, IBM is using it in a large project, the involved people are in CC.
Thomas has 3+ customers who use it, I've added him to CC.

I'm working for Nokia now and we use it. We also develop a new file
system on top of UBI and Nokia invests money in it. So UBI is going to
be maintained.

Also there was enough questions interest in the MTD mailing lists as
well. Particularly, a guy from @sunsung.com was interested.

P.S. Just for the reference, here is the URL of the new file-system
development tree (we have just started):
git://git.infradead.org/~dedekind/jffs3-2.6.git
or gitweb
http://git.infradead.org/?p=users/dedekind/jffs3-2.6.git;a=summary

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

