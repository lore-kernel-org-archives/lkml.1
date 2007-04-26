Return-Path: <linux-kernel-owner+w=401wt.eu-S933153AbXDZI2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbXDZI2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 04:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933465AbXDZI2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 04:28:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56639 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933153AbXDZI2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 04:28:07 -0400
Date: Thu, 26 Apr 2007 10:27:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070426082707.GC6873@elte.hu>
References: <20070425214704.GA32572@elte.hu> <20070426032923.GB1548@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426032923.GB1548@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
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


* Nick Piggin <npiggin@suse.de> wrote:

> >  - upstream fix: SysRq-T should show runnable tasks
> 
> BTW. can you send this upstream? It is very annoying how it currently 
> works, and I've had more than one bug that required seeing runnable 
> tasks in order to diagnose and fix...

yeah, sent it to lkml yesterday, a few minutes after having figured it 
out.

	Ingo
