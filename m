Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbXK0Mx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbXK0Mx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 07:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbXK0Mxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 07:53:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52007 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbXK0Mxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 07:53:49 -0500
Date: Tue, 27 Nov 2007 13:53:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       Dipankar <dipankar@in.ibm.com>
Subject: Re: [Patch 0/5] sched: group scheduler related patches (V4)
Message-ID: <20071127125312.GA28019@elte.hu>
References: <20071119150312.GA2365@linux.vnet.ibm.com> <20071119152258.GB31426@elte.hu> <20071119160647.GV3359@linux.vnet.ibm.com> <20071119190057.GA12650@elte.hu> <20071126050044.GA5304@linux.vnet.ibm.com> <20071126050905.GF5304@linux.vnet.ibm.com> <20071126202836.GA17012@elte.hu> <20071127050652.GA20083@linux.vnet.ibm.com> <20071127110910.GB16273@elte.hu> <20071127114246.GB22197@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127114246.GB22197@linux.vnet.ibm.com>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> On Tue, Nov 27, 2007 at 12:09:10PM +0100, Ingo Molnar wrote:
> > thanks, it looks good - but the fact that we are at v4 of the patchset 
> > underlines the point that this is more of a v2.6.25 patchset than a 
> > v2.6.24 one.
> 
> Fine. I will resubmit this patchset then once we are into 2.6.25 
> cycle.

no need (unless you have bugfixes) i'm carrying this around in the 
scheduler git tree. (it will show up in sched-devel.git)

	Ingo
