Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbZD0O55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbZD0O55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbZD0O5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:57:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48088 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbZD0O5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:57:47 -0400
Date: Mon, 27 Apr 2009 10:57:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Davide Libenzi <davidel@xmailserver.org>
cc: Andi Kleen <ak@linux.intel.com>, Huang Ying <ying.huang@intel.com>,
       Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
In-Reply-To: <alpine.DEB.1.10.0904270738470.9296@makko.or.mcafeemobile.com>
Message-ID: <alpine.DEB.2.00.0904271051220.24293@gandalf.stny.rr.com>
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com>  <20090422092259.GC18226@elte.hu> <20090422101600.GL3226@erda.amd.com>  <1240553210.6842.871.camel@yhuang-dev.sh.intel.com>  <20090424100943.GJ27264@erda.amd.com> 
 <alpine.DEB.2.00.0904240935140.24293@gandalf.stny.rr.com> <1240818596.6842.1001.camel@yhuang-dev.sh.intel.com> <49F5646F.4000305@linux.intel.com> <alpine.DEB.2.00.0904271027580.24293@gandalf.stny.rr.com>
 <alpine.DEB.1.10.0904270738470.9296@makko.or.mcafeemobile.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 27 Apr 2009, Davide Libenzi wrote:

> On Mon, 27 Apr 2009, Steven Rostedt wrote:
> 
> > Once it is filed then I can post it, I do not need to wait till it is 
> > done.
> > 
> > And what the hell do you mean about not using patents?? We have several 
> > patents in the kernel. Have you ever heard of the Open Invention Network?
> > 
> >  http://www.openinventionnetwork.com/
> > 
> > This patent will go under the Open Source patent pool to help 
> > protect against patent attacks against Linux, et. al.
> > 
> > Yes, the Open Source community can file their own patents. The more 
> > patents owned by the Open Source community, the better.
> 
> IANAL, but what is the point of it? If that's for OSS IP protection 
> against Evil Corporate claims, isn't the only fact that you posted the 
> code and algorirthm, constitutes Prior Art, that would automatically 
> protect your contribution from future claims?

Not always. There could be patent applications that have been out before 
you posted. But what you want is not to be on the defensive side only. If 
a company comes and attacks you over a patent they own, you pull out all 
your patents and look to see if the company that is attacking you is using 
anything you own.

As I said, the more patents that the Open Source community owns the 
better. The Open Invention Network is posed to counter attack any company 
that tries to attack a free software group. It is not just to counter with 
prior art, but also threaten the company that is attacking.

-- Steve

