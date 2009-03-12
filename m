Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbZCLMXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbZCLMXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZCLMXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:23:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45081 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbZCLMXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:23:03 -0400
Date: Thu, 12 Mar 2009 13:22:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/6] Futex fixes and cleanups
Message-ID: <20090312122233.GA24185@elte.hu>
References: <20090312075349.9856.83687.stgit@Aeon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312075349.9856.83687.stgit@Aeon>
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


* Darren Hart <dvhltc@us.ibm.com> wrote:

> Hi Ingo,
> 
> Here are some assorted futex fixes that I was hoping to get 
> upstream in preparation for my requeue_pi patchset in the near 
> future.  They can found at the following git repository:

applied, thanks Darren!

I'm wondering, which ones are 2.6.29 must-have's?

	Ingo
