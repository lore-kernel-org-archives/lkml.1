Return-Path: <linux-kernel-owner+w=401wt.eu-S1752269AbYIJM1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbYIJM1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbYIJM0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:26:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38143 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbYIJM0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:26:50 -0400
Date: Wed, 10 Sep 2008 14:26:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Ma, Chinang" <chinang.ma@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 OLTP performance regression
Message-ID: <20080910122622.GG14757@elte.hu>
References: <BC02C49EEB98354DBA7F5DD76F2A9E8002FE60F751@azsmsx501.amr.corp.intel.com> <1220896833.18239.141.camel@twins.programming.kicks-ass.net> <1220897052.18239.147.camel@twins.programming.kicks-ass.net> <BC02C49EEB98354DBA7F5DD76F2A9E8002FE6E71C7@azsmsx501.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BC02C49EEB98354DBA7F5DD76F2A9E8002FE6E71C7@azsmsx501.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ma, Chinang <chinang.ma@intel.com> wrote:

> Peter,
>         We increased sched_shares_ratelimit and were able to recover 
> the 2% performance regression. [...]

great. Could you please post a patch for that?

	Ingo
