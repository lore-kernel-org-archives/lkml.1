Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYFFN3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYFFN3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 09:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbYFFN27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 09:28:59 -0400
Received: from relay2.sgi.com ([192.48.171.30]:57127 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753063AbYFFN26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:28:58 -0400
Message-ID: <48493B95.5070706@sgi.com>
Date: Fri, 06 Jun 2008 06:28:53 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 5
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>	<20080605195604.41623687.akpm@linux-foundation.org>	<20080606071707.GB9708@elte.hu>	<20080606002957.6329a0ec.akpm@linux-foundation.org>	<20080606024811.70db9ab2.akpm@linux-foundation.org> <20080606035413.37f340ef.akpm@linux-foundation.org>
In-Reply-To: <20080606035413.37f340ef.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 6 Jun 2008 02:48:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> I'll try a linear search starting at
> 
> 	ff0e010ef613b0e7136f2f40ec4b51273676b085
> 	Author: Mike Travis <travis@sgi.com>  2008-05-12 12:21:12
> 	Committer: Thomas Gleixner <tglx@linutronix.de>  2008-05-23 09:05:25
> 	Parent: b65e04b53ffcb4002737a5346c9ff8865c37be58 (x86: don't call pxm_to_node again)
> 	Child:  dfdf1d75efee39e9396f8384c6f3bf555349ed60 (x86: modify Kconfig to allow up to 4096 cpus)
> 	Branch: 
> 	Follows: v2.6.26-rc2
> 	Precedes: next-20080526
> 
> 	    x86: fix remove cpu_pda table patch
> 
> 
> Good
> 
> 	dfdf1d75efee39e9396f8384c6f3bf555349ed60
> 	Author: Mike Travis <travis@sgi.com>  2008-05-12 12:21:12
> 	Committer: Thomas Gleixner <tglx@linutronix.de>  2008-05-23 09:05:39
> 	Parent: ff0e010ef613b0e7136f2f40ec4b51273676b085 (x86: fix remove cpu_pda table patch)
> 	Child:  29657a44f8660acd8751d7e9f5aac06ec8633481 (x86: cleanup early per cpu variables/accesses v4)
> 	Branch: 
> 	Follows: v2.6.26-rc2
> 	Precedes: next-20080526
> 
> 	    x86: modify Kconfig to allow up to 4096 cpus
> 
> Good
> 
> 	29657a44f8660acd8751d7e9f5aac06ec8633481
> 	Author: Mike Travis <travis@sgi.com>  2008-05-12 12:21:12
> 	Committer: Thomas Gleixner <tglx@linutronix.de>  2008-05-23 09:07:23
> 	Parent: dfdf1d75efee39e9396f8384c6f3bf555349ed60 (x86: modify Kconfig to allow up to 4096 cpus)
> 	Child:  543e21916497be5a4005fd5820264ce1de9bd56d (x86: restore pda nodenumber field)
> 	Branch: 
> 	Follows: v2.6.26-rc2
> 	Precedes: next-20080526
> 
> 	    x86: cleanup early per cpu variables/accesses v4
> 
> Good
> 
> 
> 	543e21916497be5a4005fd5820264ce1de9bd56d
> 	Author: Mike Travis <travis@sgi.com>  2008-05-12 12:21:12
> 	Committer: Thomas Gleixner <tglx@linutronix.de>  2008-05-23 09:07:37
> 	Parent: 29657a44f8660acd8751d7e9f5aac06ec8633481 (x86: cleanup early per cpu variables/accesses v4)
> 	Child:  a9ad585c8a18f7ba754b85f5786976609b9d7d29 (x86: remove the static 256k node_to_cpumask_map)
> 	Branch: 
> 	Follows: v2.6.26-rc2
> 	Precedes: next-20080526
> 
> 	    x86: restore pda nodenumber field
> 
> Good
> 
> 	a9ad585c8a18f7ba754b85f5786976609b9d7d29
> 	Author: Mike Travis <travis@sgi.com>  2008-05-12 12:21:12
> 	Committer: Thomas Gleixner <tglx@linutronix.de>  2008-05-23 09:07:47
> 	Parent: 543e21916497be5a4005fd5820264ce1de9bd56d (x86: restore pda nodenumber field)
> 	Child:  78d49c6d890aee9cf8aea371011c9d7b0121b822 (x86: remove static boot_cpu_pda array v2)
> 	Branch: 
> 	Follows: v2.6.26-rc2
> 	Precedes: next-20080526
> 
> 	    x86: remove the static 256k node_to_cpumask_map
> 
> crash, as described earlier.
> 
> I don't know what happened to that early exception - it didn't come back.
> 
> The below revert gets linux-next working for me.

Did you try using the DEBUG_PER_CPU_MAPS option?  This should trigger on any
use of the node_to_cpumask map before it's been allocated.  (Hmm, I should
check if it also validates the node number - as when MAX_NUMNODES is used
instead of nr_node_ids.)

Also, could you send me the config file and a short description of what kind
of system you are testing on?

Thanks,
Mike
