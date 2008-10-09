Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbYJIOUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbYJIOUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 10:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758000AbYJIOUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 10:20:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:56253 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905AbYJIOUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 10:20:09 -0400
Subject: Re: [RFC PATCH v2 0/5] sched: modular find_busiest_group()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
In-Reply-To: <20081009120705.27010.12857.stgit@drishya.in.ibm.com>
References: <20081009120705.27010.12857.stgit@drishya.in.ibm.com>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 16:19:28 +0200
Message-Id: <1223561968.7382.42.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I've looked over the last posting, but so far failed to respond :/

While I like the clean-up, I'm atm a bit reluctant to apply, as I'm
trying to rework the sched_domain stuff and the HT balancing and I'm not
quite sure how this will interact with your patches.

I hope to share my proposal (in talk - no patches yet) soonish (this
weekend, early next week) so that we can discuss it.

Thanks for you patience,

Peter

