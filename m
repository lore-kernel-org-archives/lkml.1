Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYLAMpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYLAMpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbYLAMpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:45:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46174 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbYLAMpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:45:09 -0500
Date: Mon, 1 Dec 2008 13:44:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: arun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       bharata@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com
Subject: Re: [PATCH] sched: add uid information to sched_debug for
	CONFIG_USER_SCHED
Message-ID: <20081201124452.GA21534@elte.hu>
References: <20081201112954.GH20329@linux.vnet.ibm.com> <1228131416.7251.306.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228131416.7251.306.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2008-12-01 at 16:59 +0530, Arun R Bharadwaj wrote:
> > Hi,
> > 
> > This patch adds uid information in sched_debug for CONFIG_USER_SCHED
> 
> I'd much rather have people working at removing USER_SCHED,. but sure,
> the patch looks sane..

ok, i have applied it to tip/sched/core.

Thanks,

	Ingo
