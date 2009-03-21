Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZCUWWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZCUWWx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 18:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbZCUWWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 18:22:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52387 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbZCUWWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 18:22:44 -0400
Date: Sat, 21 Mar 2009 18:20:30 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090321222030.GA5157@redhat.com>
References: <20090321074301.GA19384@elte.hu> <20090321013912.ed6039c9.akpm@linux-foundation.org> <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu> <20090321143413.75ead1aa.akpm@linux-foundation.org> <20090321215145.GB5262@redhat.com> <alpine.LFD.2.00.0903211501060.3030@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903211501060.3030@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sat, Mar 21, 2009 at 03:02:59PM -0700, Linus Torvalds wrote:
> [...]
> > The thing is, utrace crashes in Fedora have dominated kerneloops.org 
> > for many months [...]
> 
> .. and dammit, I agree 100%. If utrace really shows up in _any_ way on 
> kerneloops.org, then I think THE ENTIRE DISCUSSION in this thread is moot. 

There was a short span of time during last fall, when Roland was on
vacation.  That bug (in 2.6.26.3) was fixed during the kernel summit.
So this is a six-month obsolete grievance.

- FChE
