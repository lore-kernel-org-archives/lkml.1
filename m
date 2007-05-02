Return-Path: <linux-kernel-owner+w=401wt.eu-S1766866AbXEBT7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766866AbXEBT7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766875AbXEBT7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:59:30 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:35793 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766866AbXEBT72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:59:28 -0400
Date: Wed, 2 May 2007 15:59:27 -0400
To: Diego Calleja <diegocg@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070502195927.GJ5577@csclub.uwaterloo.ca>
References: <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk> <20070428224904.GE3468@stusta.de> <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <20070429173500.GA30248@one.firstfloor.org> <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org> <20070429180909.GA30604@one.firstfloor.org> <20070429214007.9ea12e96.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429214007.9ea12e96.diegocg@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 09:40:07PM +0200, Diego Calleja wrote:
> So far, it seems that most of people's opinion WRT to bug reporting and trackingcan
> be divided into 2 groups:
> 
> - People who argues (and they're right) that bugzilla and web interfaces in general
>   suck and that email + an "Adrian-like" solution works better
> 
> - People who argues that a bug tracker better than a mailing list is absolutely
>   needed (and they're right). They also argue that while bugzilla sucks, it's
>   better than nothing.
> 
> There's a common point between both groups: bugzilla sucks. The ideal
> solution would be to replace bugzilla with some alternative and better
> opensource bug tracking software, but I doubt it exists (there must be a
> reason why everybody uses bugzilla). A good bug tracker should feel like
> it makes your work easier, instead of making you feel like you're wasting
> time (which is what bugzilla does)

Debian has a bug track system which interacts mainly with the users
through email.  Seems rather nice to use and doesn't make you sign up to
submit things, and has no issues with mailing lists being "subscribed"
to a bug.  Probably a bit complicated to setup though.

> I don't see why a web interface bug tracker should be bad for bug tracking,
> as long as it's good and integrates 100% in the mailing lists. In my humble
> opinion the "perfect" bug tracker for Linux should be something like this:
> - Has a email interface (like the Debian bug tracking database).
> - Has a web interface that completely follows the email threads
>    (reading/posting), but make the comments real emails, not just
>     database fields.
> If done well (unlike the current bugzilla-to-email hack), it should possible
> to do many nice things, like add a lkml bug report to the bug tracking
> database (which shouldn't be a "real" database, but just an lkml mail
> archive with a list of message IDs that are considered a bug and its state)
> by just replying the thread, CCing the bug tracker and telling him to include
> the thread in the database.

So in other words, basically the debian bug track system, except
perhaps with an ability to submit bugs through a web interface too
rather than just email and reportbug (which I believe uses email).

> So unless someone is willing to write such tool (which I doubt, since it
> doesn't looks easy), all this discussion seems pointless, and we should
> stick with this http://kernelnewbies.org/known_regressions page
> which is showing to be quite useful :)

--
Len Sorensen
