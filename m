Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab0CKK57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:57:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35880 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab0CKK54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:57:56 -0500
Date: Thu, 11 Mar 2010 11:56:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Sch?ne <robert.schoene@tu-dresden.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Patch for tracing c states (power_end) on x86
Message-ID: <20100311105654.GB27207@elte.hu>
References: <1266999573.3415.8.camel@localhost>
 <1267102320.12790.139.camel@laptop>
 <1268289377.3374.13.camel@localhost>
 <1268295123.5279.859.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268295123.5279.859.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2010-03-11 at 07:36 +0100, Robert Sch??ne wrote:
> > Did anyone look at the problem described and checked the patch?
> > I still received no reply.
> 
> Ingo, how about applying it and letting people complain when they don't 
> agree? :-)

We can do that. Robert, mind sending the patch with a changelog and with your 
Signed-off-by and with Peter's Acked-by?

Thanks,

	Ingo
