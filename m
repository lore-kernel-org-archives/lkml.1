Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbXIYGrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbXIYGrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 02:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbXIYGrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 02:47:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43284 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbXIYGq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 02:46:59 -0400
Date: Tue, 25 Sep 2007 08:45:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925064522.GA1568@elte.hu>
References: <20070924214537.GA18980@elte.hu> <1190678882.2634.1.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190678882.2634.1.camel@imap.mvista.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> On Mon, 2007-09-24 at 23:45 +0200, Ingo Molnar wrote:
> > Lots of scheduler updates in the past few days, done by many people. 
> > Most importantly, the SMP latency problems reported and debugged by
> > Mike 
> > Galbraith should be fixed for good now. 
> 
> Does this have anything to do with idle balancing ? I noticed some 
> fairly large latencies in that code in 2.6.23-rc's ..

any measurements?

	Ingo
