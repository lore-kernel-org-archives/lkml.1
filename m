Return-Path: <linux-kernel-owner+w=401wt.eu-S1031072AbXDQEHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031072AbXDQEHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 00:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031073AbXDQEHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 00:07:07 -0400
Received: from omta05sl.mx.bigpond.com ([144.140.93.195]:39012 "EHLO
	omta05sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031072AbXDQEHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 00:07:05 -0400
Message-ID: <462447E0.20806@bigpond.net.au>
Date: Tue, 17 Apr 2007 14:06:56 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
References: <20070416220715.GA4071@elte.hu>
In-Reply-To: <20070416220715.GA4071@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta05sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 17 Apr 2007 04:07:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> this is the second release of the CFS (Completely Fair Scheduler) 
> patchset, against v2.6.21-rc7:
> 
>    http://redhat.com/~mingo/cfs-scheduler/sched-cfs-v2.patch
> 
> i'd like to thank everyone for the tremendous amount of feedback and 
> testing the v1 patch got - i could hardly keep up with just reading the 
> mails! Some of the stuff people addressed i couldnt implement yet, i 
> mostly concentrated on bugs, regressions and debuggability.

Can I make a suggestion?

Would it be possible (from now on) to publish changes relevant to the 
previous patch (eventually leading to a series of patches that describes 
the evolution of the new scheduler) so that it's easier for us 
reviewers/critics to see the latest changes.  E.g. if import such 
changes into something like quilt (using my gquilt GUI wrapper, of 
course :-)) I can then use meld (or similar) to follow what's going as 
suggestions get folded in and bugs get fixed etc.

Thanks
Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
