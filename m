Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbYKWJxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbYKWJxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 04:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbYKWJxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 04:53:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47978 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbYKWJxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 04:53:24 -0500
Date: Sun, 23 Nov 2008 10:53:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] irq.h: fix missing/extra kernel-doc
Message-ID: <20081123095311.GS30453@elte.hu>
References: <4927598D.3090505@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4927598D.3090505@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix missing & excess irq.h kernel-doc:
> 
> Warning(include/linux/irq.h:182): No description found for parameter 'irq'
> Warning(include/linux/irq.h:182): Excess struct/union/enum/typedef member 'affinity_entry' description in 'irq_desc'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  include/linux/irq.h |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

applied to tip/irq/urgent, thanks Randy!

	Ingo
