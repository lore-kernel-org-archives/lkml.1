Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbXFWHMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbXFWHMa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 03:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbXFWHMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 03:12:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58291 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbXFWHMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 03:12:22 -0400
Date: Sat, 23 Jun 2007 09:11:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070623071153.GB6845@elte.hu>
References: <20070622220202.GA16872@elte.hu> <200706221908.05460.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706221908.05460.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gene Heskett <gene.heskett@gmail.com> wrote:

> patching file kernel/softirq.c
> patching file kernel/sysctl.c
> The next patch would delete the file l/kernel/sched.c,
> which does not exist!  Assume -R? [n]
> 
> How to proceed?

oops - just ignore it, or re-download the patch (i fixed it).

	Ingo
