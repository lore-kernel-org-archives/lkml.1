Return-Path: <linux-kernel-owner+w=401wt.eu-S1759023AbZD0Ow3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023AbZD0Ow3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758756AbZD0Oty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:49:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38438 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757688AbZD0Otx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:49:53 -0400
Date: Mon, 27 Apr 2009 10:49:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <ak@linux.intel.com>
cc: Huang Ying <ying.huang@intel.com>, Robert Richter <robert.richter@amd.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Patenting kernel patches was Re: Re-implement MCE log ring buffer
 as per-CPU ring buffer
In-Reply-To: <49F5C305.60807@linux.intel.com>
Message-ID: <alpine.DEB.2.00.0904271047360.24293@gandalf.stny.rr.com>
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com>  <20090422092259.GC18226@elte.hu> <20090422101600.GL3226@erda.amd.com>  <1240553210.6842.871.camel@yhuang-dev.sh.intel.com>  <20090424100943.GJ27264@erda.amd.com> 
 <alpine.DEB.2.00.0904240935140.24293@gandalf.stny.rr.com> <1240818596.6842.1001.camel@yhuang-dev.sh.intel.com> <alpine.DEB.2.00.0904271026140.24293@gandalf.stny.rr.com> <49F5C305.60807@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 27 Apr 2009, Andi Kleen wrote:
> > Yes, I plan on being able to post it before the 31 merge window opens. I'll
> > ping the lawyer to expedite the process.
> 
> Sorry, but this is quite ridiculous. Are you serious?

Yes.

> 
> Why would we want such a patented algorithm in the kernel? Normally the
> standard
> policy is to avoid patented algorithms (unless there's really no alternative
> like
> with RCU which is clearly not the case here) and I'm not aware of this policy
> haven't
> changed.
> 
> And also holding up perfectly good uncontaminated patches for something
> patented seems especially wrong.
> 
> I think we should move forward with a standard non patented ring
> buffer Ying was working on for this and avoid the patent mess as
> far as possible.

In the world where patents can destroy Open Source/Free Software, one of 
the protections that Free Software can do is to file their own patents. 
Thus fight fire with fire.

> 
> -Andi (who wonders if he isn't in bizarro land now)

Welcome to bizarro land!

-- Steve

