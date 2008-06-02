Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbYFBLCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbYFBLCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYFBLB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:01:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36145 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbYFBLBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:01:55 -0400
Date: Mon, 2 Jun 2008 13:01:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched: update the sched-domains debug documentation
Message-ID: <20080602110139.GC14598@elte.hu>
References: <20080529070618.GA28006@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529070618.GA28006@in.ibm.com>
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

> Author: Gautham R Shenoy <ego@in.ibm.com>
> Date:   Thu May 29 12:33:15 2008 +0530
> 
>     sched: Update the sched-domains debug documentation.
> 
>     SCHED_DOMAIN_DEBUG mentioned in the Documentation for sched-domains
>     for enabling sched-domains debugging doesn't exist anymore.
> 
>     Update the documentation to reflect the correct way of enabling
>     sched-domain debugging.
> 
>     Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>

applied to tip/sched-devel - thanks Gautham.

	Ingo
