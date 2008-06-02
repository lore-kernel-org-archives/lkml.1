Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYFBLEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYFBLEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbYFBLD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:03:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36660 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbYFBLD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:03:58 -0400
Date: Mon, 2 Jun 2008 13:03:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched: Print the sd->level in sched_domain_debug code
Message-ID: <20080602110352.GE14598@elte.hu>
References: <20080529152632.GB28006@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529152632.GB28006@in.ibm.com>
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


* Gautham R Shenoy <ego@in.ibm.com> wrote:

> sched: Print the sd->level in sched_domain_debug code
> 
> From: Gautham R Shenoy <ego@in.ibm.com>
> 
> While printing out the visual representation of the sched-domains, print
> the level (MC, SMT, CPU, NODE, ... ) of each of the sched_domains.
> 
> Credit: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>

applied to tip/sched-devel. Thanks,

	Ingo
