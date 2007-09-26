Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbXIZN6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbXIZN6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbXIZN6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:58:03 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:56871 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbXIZN6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:58:01 -0400
Date: Wed, 26 Sep 2007 16:47:44 +0530
To: Jaswinder Singh <jaswinderlinux@gmail.com>
Cc: hufey <hufeyy@gmail.com>, linux-kernel@vger.kernel.org, mingo@elte.hu,
       dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       randy.dunlap@oracle.com, efault@gmx.de, akpm@linux-foundation.org,
       vatsa@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com
Subject: Re: realtime preemption performance difference
Message-ID: <20070926111744.GA18438@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <3f9a31f40709240448h4a9e8337t437328b5c675ecd5@mail.gmail.com> <88dfed9d0709241427v329aeed9jfbc298666ac483c8@mail.gmail.com> <3f9a31f40709260011i1416d287h5d0da001dd77fbfb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40709260011i1416d287h5d0da001dd77fbfb@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: ankita@in.ibm.com (Ankita Garg)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaswinder,

On Wed, Sep 26, 2007 at 12:41:57PM +0530, Jaswinder Singh wrote:
> hello hufey,
> 
> I am not using montavista kernel, I am using standard linux kernel.
> 
> Realtime is known by worst case latencies. Ingo and team are claiming
> for realtime support so their should be some samples and performance
> numbers,
> 

You can obtain several -rt testcases from the RT wiki:
http://rt.wiki.kernel.org/index.php/Main_Page Here we have testcases/benchmarks 
for measuring scheduling latencies, priority preemption, signaling latencies, etc 
and other important information on the patchset.

Hope this helps!

> Can someone please share their samples and/or numbers.
> 
> Thank you,
> 
> Jaswinder Singh.
> 
> On 9/25/07, hufey <hufeyy@gmail.com> wrote:
> > On 9/24/07, Jaswinder Singh <jaswinderlinux@gmail.com> wrote:
> > > Hi all,
> > >
> > > I want to check performance difference by using realtime preemption patch :
> > >
> > > http://www.kernel.org/pub/linux/kernel/projects/rt/
> > >
> > > Please let me know from where I can download samples to test realtime
> > > preemption performance difference.
> > >
> >
> > As far as I know, some embedded linux vendors such as MontaVista
> > provide kernel patch to export some interfaces to measure realtime
> > performance.
> >
> > > Can someone please share performance numbers for your hardware:-
> > >
> > > 1. Interrupt latency
> > > 2. Task switching time
> > > 3. hard-realtime scheduling latency
> > >
> > > Thank you,
> > >
> > > Jaswinder Singh.
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > >
> >
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   
