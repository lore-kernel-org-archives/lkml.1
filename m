Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbXJFGB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbXJFGB4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 02:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbXJFGBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 02:01:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35738 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751342AbXJFGBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 02:01:46 -0400
Date: Fri, 5 Oct 2007 23:01:41 -0700
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       randy.dunlap@oracle.com, menage@google.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, cpw@sgi.com
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag fixes
Message-Id: <20071005230141.63a1f6c3.pj@sgi.com>
In-Reply-To: <20071006055324.GC23397@elte.hu>
References: <20071003114401.32194.73464.sendpatchset@jackhammer.engr.sgi.com>
	<20071005161305.af27f452.akpm@linux-foundation.org>
	<20071005163918.46d40fed.pj@sgi.com>
	<20071006055324.GC23397@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo wrote:
> please resend the base patch to Andrew (or better yet, a combo patch 
> that Andrew can apply and which just does it all).

I'm reluctant to right now, because I will be off the air
for three days, starting in one more day, and don't like
firing off stuff just before I vanish.

Though I'm aware that time is short for 2.6.24 ... not
sure how best to handle this.

My plan had been to send Andrew something on Wednesday
next week (five days from now), either what we have now,
or with the improved cpuset-to-sched API, if Nick and I
can work through that (well, if Nick can figure out what
I broke, while I'm offline.)

Andrew or Ingo - you got any better plan?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
