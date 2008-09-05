Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbYIERIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbYIERIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYIERIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:08:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44167 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbYIERIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:08:07 -0400
Date: Fri, 5 Sep 2008 19:07:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Dean Nelson <dcn@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] error missed ifndef CONFIG_HAVE_SPARSE_IRQ
Message-ID: <20080905170751.GC12645@elte.hu>
References: <20080905140720.GA9393@sgi.com> <20080905144648.GA10292@elte.hu> <86802c440809051003o6829e7d5i2dd683f5e0dd0ae4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809051003o6829e7d5i2dd683f5e0dd0ae4@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Fri, Sep 5, 2008 at 7:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Dean Nelson <dcn@sgi.com> wrote:
> >
> >> An error return from create_irq_nr() is 0, but an error return from
> >> create_irq() is -1.
> >>
> >> Signed-off-by: Dean Nelson <dcn@sgi.com>
> >
> > applied to tip/irq/sparseirq - thanks Dean!
> >
> need to change irq to int too

applied to tip/irq/sparseirq - thanks.

	Ingo
