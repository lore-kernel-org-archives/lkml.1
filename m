Return-Path: <linux-kernel-owner+w=401wt.eu-S1761355AbYFLMcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355AbYFLMcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759616AbYFLMce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:32:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44739 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759165AbYFLMcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:32:33 -0400
Date: Thu, 12 Jun 2008 14:32:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [patch 0/6] AMD C1E aware idle support
Message-ID: <20080612123212.GA8085@elte.hu>
References: <20080610171639.551369443@linutronix.de> <200806121431.24305.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806121431.24305.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > http://www.kernel.org/pub/linux/kernel/people/tglx/c1e/2.6.26-rc5-c1e-patches.tar.gz
> > or
> > http://www.kernel.org/pub/linux/kernel/people/tglx/c1e/2.6.26-rc5-c1e-patches.tar.bz2
> 
> I guess the x86-next-apic-timer-fixes.patch is a combination of all 
> patches in this series.  Is that correct?

you can also try out those patches via running tip/master. (the patches 
from Thomas are queued up in the tip/x86/cpu topic branch)

	Ingo
