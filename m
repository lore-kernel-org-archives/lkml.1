Return-Path: <linux-kernel-owner+w=401wt.eu-S1765836AbXIMTAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765836AbXIMTAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760894AbXIMTAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:00:04 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39092 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760813AbXIMTAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:00:01 -0400
Date: Thu, 13 Sep 2007 21:01:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] CFS-devel, performance improvements
Message-ID: <20070913190125.GC27146@uranus.ravnborg.org>
References: <20070911200459.GA6974@elte.hu> <Pine.LNX.4.64.0709120242040.1817@scrub.home> <20070913075258.GA9173@elte.hu> <Pine.LNX.4.64.0709131419170.1817@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709131419170.1817@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman.

On Thu, Sep 13, 2007 at 02:35:35PM +0200, Roman Zippel wrote:
> Hi,
> 
> On Thu, 13 Sep 2007, Ingo Molnar wrote:
> 
> > > Out of curiousity: will I ever get answers to my questions?
> > 
> > the last few weeks/months have been pretty hectic - i get more than 50 
> > non-list emails a day so i could easily have missed some.
> 
> Well, let's just take the recent "Really Simple Really Fair Scheduler" 
> thread. You had the time to ask me questions about my scheduler, I even 
> explained to you how the sleeping bonus works in my model. At the end I 
> was sort of hoping you would start answering my questions and explaining 
> things how the same things work in CFS - but nothing.
> Then you had the time to reimplement the very things you've just asked me 
> about and what do I get credit for - "two cleanups from RFS".

I have read the announcement from Ingo and after reading it I concluded
that it was good to see that Ingo had taken in consideration the feedback
from you and improved the schduler based on this.
And when I read that he removed a lot of stuff I smiled. This reminded
me of countless monkey aka code review sessions where I repeatedly do
like my childred and asks why so many times that the author realize that
something is not needed or no longer used.


The above were my impression after reading the announcement with
respect to your influence and that goes far beyond "two cleanups".
I bet many others read it roughly like I did.

And no - I did not go back and re-read it. So do not answering
by quoting the announcement or stuff like this.
Because that will NOT change what my first impression was.

So keep up the review - we get a better scheduler this way.

	Sam
