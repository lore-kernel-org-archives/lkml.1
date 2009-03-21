Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbZCUWI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbZCUWI1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 18:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZCUWIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 18:08:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbZCUWIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 18:08:17 -0400
Date: Sat, 21 Mar 2009 15:02:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
In-Reply-To: <20090321215145.GB5262@redhat.com>
Message-ID: <alpine.LFD.2.00.0903211501060.3030@localhost.localdomain>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com> <20090321014244.9ADF1FC3AB@magilla.sf.frob.com> <20090321074301.GA19384@elte.hu> <20090321013912.ed6039c9.akpm@linux-foundation.org> <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org>
 <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu> <20090321143413.75ead1aa.akpm@linux-foundation.org> <20090321215145.GB5262@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 21 Mar 2009, Frank Ch. Eigler wrote:
> 
> > If testing utrace against its main application requires installation
> > of a complete enterprise distro from a distro [...]
> 
> This has *never* been a requirement.

You guys are getting off a tangent.

Let's go back to the post that started this all.

> The thing is, utrace crashes in Fedora have dominated kerneloops.org 
> for many months, so i'm not sure what to make of the idea of posting 
> a 4000+ lines of core kernel code patchset on the last day of the 
> development cycle, a posting that has carefully avoided the Cc:-ing 
> of affected maintainers ;-)

.. and dammit, I agree 100%. If utrace really shows up in _any_ way on 
kerneloops.org, then I think THE ENTIRE DISCUSSION in this thread is moot. 

I'm not going to take known-bad crap. It's that simple. Don't bother 
posting it, don't bother discussing it, don't bother making excuses for 
it.

			Linus
