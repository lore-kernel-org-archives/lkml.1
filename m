Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbYJTW2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbYJTW2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbYJTW1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:27:11 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37795 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbYJTW1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:27:09 -0400
Date: Tue, 21 Oct 2008 01:24:35 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Greg KH <greg@kroah.com>
Cc: Felipe Balbi <felipe.balbi@nokia.com>, Willy Tarreau <w@1wt.eu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081020222434.GF26744@gandalf.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com> <20081017174657.GH2221@kroah.com> <20081017204723.15114eaa@lxorguk.ukuu.org.uk> <20081017214409.GB3585@kroah.com> <20081018084504.GQ24654@1wt.eu> <20081020203033.GB20788@kroah.com> <20081020205400.GB26744@gandalf.research.nokia.com> <20081020210648.GA30389@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020210648.GA30389@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 20 Oct 2008 22:24:40.0634 (UTC) FILETIME=[A4E741A0:01C93302]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 02:06:48PM -0700, Greg KH wrote:
> On Mon, Oct 20, 2008 at 11:54:00PM +0300, Felipe Balbi wrote:
> > On Mon, Oct 20, 2008 at 01:30:33PM -0700, Greg KH wrote:
> > > > IMHO, having a small number of small digits is the way to go. Using
> > > > 1 or 2 digits for the major and 1 for the minor is fine. After 3.9, you
> > > > go to version 4.0. Anyway, there are so many changes between versions
> > > > these days that any new versions could justify a major change (eg:
> > > > check the size of the 2.6.27 patch).
> > > > 
> > > > With versions from 1.1 to 9.9, you can go as high as 88 versions,
> > > > which is about 22 years of development at current pace. After that,
> > > > we can simply turn to 10.0 and not break anything.
> > > > 
> > > > It's also easier for users. Check how many non-kernel techies around you
> > > > know all 3 digits of the version they use. It's easier to remember 4.3
> > > > than it is to remember 2.6.27.
> > > 
> > > I agree that would be nicer, and easier for everyone.
> > 
> > It's true it would be easier for tracking down and remembering the
> > version number, but on the other hand, the good thing about this
> > version number system is that we now 2.6.xx is a rather stable and
> > complete kernel tree and when we move to 2.7, we know it'll be the start
> > for the 2.8 kernel series.
> 
> Um, did you not get the memo 3 years ago saying we are changing our
> development model and there will not be a 2.7 development series?
> 
> Damm, I thought I had printed it out and placed it on everyone's chairs.
> Those pesky cleaners must have picked it up and recycled it, sorry about
> that...
> 
> > Just like the migration from 2.4 to 2.5.
> 
> Please don't bring up the dark ages again, many of us went through
> things back then that have taken a lot of counseling to be able to get
> over.

sorry if i'm developing linux kernel for as long as you are. It's really
not my business how many hours of counseling you had to attend to get
over a version numbering change.

Maybe you still need a bit more, judging by your reply.

-- 
balbi
