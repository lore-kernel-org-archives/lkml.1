Return-Path: <linux-kernel-owner+w=401wt.eu-S1766690AbXDSNR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766690AbXDSNR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 09:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766693AbXDSNR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 09:17:58 -0400
Received: from mail04.syd.optusnet.com.au ([211.29.132.185]:49829 "EHLO
	mail04.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766690AbXDSNR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 09:17:57 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: Announce - Staircase Deadline cpu scheduler v0.42
Date: Thu, 19 Apr 2007 23:39:55 +1000
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, Al Boldi <a1426z@gawab.com>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Matt Mackall <mpm@selenic.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Bill Huey <billh@gnuppy.monkey.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Gene Heskett <gene.heskett@gmail.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <200704190959.06432.kernel@kolivas.org> <200704191212.15151.kernel@kolivas.org> <20070419125524.GB27584@1wt.eu>
In-Reply-To: <20070419125524.GB27584@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704192339.56144.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 April 2007 22:55, Willy Tarreau wrote:
> On Thu, Apr 19, 2007 at 12:12:14PM +1000, Con Kolivas wrote:
> > On Thursday 19 April 2007 10:41, Con Kolivas wrote:
> > > On Thursday 19 April 2007 09:59, Con Kolivas wrote:
> > > > Since there is so much work currently ongoing with alternative cpu
> > > > schedulers, as a standard for comparison with the alternative virtual
> > > > deadline fair designs I've addressed a few issues in the Staircase
> > > > Deadline cpu scheduler which improve behaviour likely in a noticeable
> > > > fashion and released version 0.41.
> > > >
> > > > http://ck.kolivas.org/patches/staircase-deadline/2.6.20.7-sd-0.41.pat
> > > >ch
> > > > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc7-sd-0.41.p
> > > >atch
> > > >
> > > > and an incremental for those on 0.40:
> > > > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc7/sched-imp
> > > >leme nt -staircase-deadline-scheduler-further-improvements.patch
> > > >
> > > > Remember to renice X to -10 for nicest desktop behaviour :)
> > > >
> > > > Have fun.
> > >
> > > Oops forgot to cc a few people
> > >
> > > Nick you said I should still have something to offer so here it is.
> > > Peter you said you never saw this design (it's a dual array affair
> > > sorry). Gene and Willy you were some of the early testers that noticed
> > > the advantages of the earlier designs,
> > > Matt you did lots of great earlier testing.
> > > WLI you inspired a lot of design ideas.
> > > Mike you were the stick.
> > > And a few others I've forgotten to mention and include.
> >
> > Version 0.42
> >
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc7-sd-0.42.patch
>
> Will give it a shoot ASAP, probably this week-end. I'm too short in time
> this week.

Great, thanks. By then there will almost certainly be a 0.43 so no rush.

-- 
-ck
