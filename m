Return-Path: <linux-kernel-owner+w=401wt.eu-S1751714AbXLCWeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbXLCWeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 17:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbXLCWeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 17:34:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54466 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbXLCWeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 17:34:12 -0500
Date: Mon, 3 Dec 2007 23:33:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <lkml@rtr.ca>
Cc: Chris Friesen <cfriesen@nortel.com>, davids@webmaster.com,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Message-ID: <20071203223353.GA20362@elte.hu>
References: <MDEHLPKNGKAHNMBLJOLKEEHJIJAC.davids@webmaster.com> <47545F88.6070609@nortel.com> <4754777F.7020302@rtr.ca> <20071203214803.GA8989@elte.hu> <47547BB6.3040402@rtr.ca> <20071203220559.GA11906@elte.hu> <475480AF.2010307@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475480AF.2010307@rtr.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Mark Lord <lkml@rtr.ca> wrote:

>> heh, thanks :) For which workload does it make the biggest difference 
>> for you? (and compared to what other scheduler you used before? 
>> 2.6.22?)
> ..
>
> Heh.. I'm just a very unsophisticated desktop user, and I like it when 
> Thunderbird and Firefox are unaffected by the "make -j3" kernel builds 
> that are often running in another window.  BIG difference there.
>
> And on the cool side, the Swarm game (swarm.swf) is a great example of 
> something that used to get jerky really fast whenever anything else 
> was running, and now it really doesn't seem to be affected by 
> anything. (I don't really play computer games, but this one is has a 
> very retro feel..).

nice! Do you feel any difference between 2.6.23 and 2.6.24-rc for these 
workloads? (if you've tried .24 already)

	Ingo
