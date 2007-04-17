Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbXDQAGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbXDQAGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 20:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbXDQAGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 20:06:52 -0400
Received: from omta01ps.mx.bigpond.com ([144.140.82.153]:30975 "EHLO
	omta01ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbXDQAGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 20:06:52 -0400
X-Greylist: delayed 82787 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2007 20:06:51 EDT
Message-ID: <46240F98.3020800@bigpond.net.au>
Date: Tue, 17 Apr 2007 10:06:48 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu>	 <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net>
In-Reply-To: <1176619384.6222.70.camel@Homer.simpson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta01ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 17 Apr 2007 00:06:49 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Sun, 2007-04-15 at 13:27 +1000, Con Kolivas wrote:
>> On Saturday 14 April 2007 06:21, Ingo Molnar wrote:
>>> [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler
>>> [CFS]
>>>
>>> i'm pleased to announce the first release of the "Modular Scheduler Core
>>> and Completely Fair Scheduler [CFS]" patchset:
>>>
>>>    http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch
>>>
>>> This project is a complete rewrite of the Linux task scheduler. My goal
>>> is to address various feature requests and to fix deficiencies in the
>>> vanilla scheduler that were suggested/found in the past few years, both
>>> for desktop scheduling and for server scheduling workloads.
>> The casual observer will be completely confused by what on earth has happened 
>> here so let me try to demystify things for them.
> 
> [...]
> 
> Demystify what?   The casual observer need only read either your attempt
> at writing a scheduler, or my attempts at fixing the one we have, to see
> that it was high time for someone with the necessary skills to step in.

Make that "someone with the necessary clout".

> Now progress can happen, which was _not_ happening before.
> 

This is true.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
