Return-Path: <linux-kernel-owner+w=401wt.eu-S1751263AbZHOJBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbZHOJBl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbZHOJBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:01:41 -0400
Received: from www.tglx.de ([62.245.132.106]:47821 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbZHOJBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:01:40 -0400
Date: Sat, 15 Aug 2009 11:01:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 00/15] clocksource / timekeeping rework V4 (resend V3 +
 bug fix)
In-Reply-To: <1250300765.8269.29.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0908151057500.1283@localhost.localdomain>
References: <20090814134717.859098725@de.ibm.com> <1250300765.8269.29.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Aug 2009, john stultz wrote:
> > Keeping the fingers crossed that this is now really done.
> > John already gave his thumbs up for the patch series, so the next
> > logical question is who is going to sit on the patches until the merge
> > window is opened? I can certainly create a git branch on git390 for
> > them, but the patches depend on some patches in the x86-tip tree.
> > Thomas, any thoughts?
> 
> So with the fix I sent out to patch #4, this set looks good to me.
> 
> So for all of them, including the fixup:
> 
> Acked-by: John Stultz <johnstul@us.ibm.com>

Thanks John for the fix. I picked up everything and pushed it into
tip/timers/core.

Martin, thanks for the nice work. FYI, I massaged the commit messages
a bit as they were missing subsystem identifiers and I added some more
explanation to some of them.

Thanks,

	tglx
