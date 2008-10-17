Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbYJQEyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbYJQEyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 00:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbYJQEyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 00:54:09 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:53399 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYJQEyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 00:54:06 -0400
Date: Thu, 16 Oct 2008 21:53:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-Id: <20081016215342.ebe31322.randy.dunlap@oracle.com>
In-Reply-To: <20081017040239.GB28188@kroah.com>
References: <20081016002509.GA25868@kroah.com>
	<20081016124943.GE23630@cs181140183.pp.htv.fi>
	<20081016151748.GA31075@kroah.com>
	<20081016153053.GJ5834@nostromo.devel.redhat.com>
	<20081016154726.GA6331@kroah.com>
	<20081016171626.GB22554@cs181140183.pp.htv.fi>
	<20081017040239.GB28188@kroah.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 21:02:39 -0700 Greg KH wrote:

> On Thu, Oct 16, 2008 at 08:16:26PM +0300, Adrian Bunk wrote:
> > On Thu, Oct 16, 2008 at 08:47:26AM -0700, Greg KH wrote:
> > You miss the best alternative:
> > 
> > Simply keep the status quo.
> 
> I'd argue that is is a pain.  Linus has expressed frustration with the
> current numbering scheme, and as someone who deals with kernel version
> numbers every single day, I too am mildly frustrated.
> 
> I think the main reason why is just that small numbers are easier to
> keep track of in your mind.  As we are ever increasing the version
> number, the release numbers feel like they are getting closer together,
> making them less distinguishable.
> 
> For example, think of the following:
> 	2.6.5 vs. 2.6.9
> Your mind focuses on the 5 and 9, and in thinking about them, it is much
> easier to keep them apart.
> 
> Now, try the same with:
> 	2.6.24 vs. 2.6.27
> You are repeating the tens digit, the "two", so it is a bit harder to
> distinguish things.  After a few years of this, it gets more difficult
> 
> So I proposed an alternative, YEAR.NUMBER.  The year is easy to keep
> track of, and the release number is a small one, making it too easier to
> track and distinguish from each other:
> 	2009.1 vs. 2009.5
> or
> 	2010.2 vs. 2011.5
> It also means something that lets you remember back to what was going on
> for that release better, if you can easily place it within a specific
> time frame, which is important for those of us who work with different
> kernel versions all the time for different projects and backports and
> stable releases.
> 
> If the number stays the same, my feeble brain will survive and I'll just
> rely on my huge spreadsheet of when specific kernels were released when
> to get along, and hopefully I will not make any more .26.5 releases when
> I mean .25.5 and such like I have in the past :)

Nah, that can/will still happen (for someone).

I still fail to see what is br0ken and needs to be fixed...

---
~Randy
