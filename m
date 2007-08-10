Return-Path: <linux-kernel-owner+w=401wt.eu-S1763118AbXHJHrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763118AbXHJHrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 03:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbXHJHrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 03:47:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38309 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbXHJHrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 03:47:07 -0400
Date: Fri, 10 Aug 2007 09:46:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Markus <lists4me@web.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070810074615.GC28264@elte.hu>
References: <20070706173319.GA2356@elte.hu> <alpine.LFD.0.999.0707171329370.27353@woody.linux-foundation.org> <20070717204358.GA12037@elte.hu> <200708091934.10962.lists4me@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708091934.10962.lists4me@web.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus <lists4me@web.de> wrote:

> Well, I am back now, but the problem still exists in 2.6.23-rc2. And 
> as there is nothing more I can do thats it for now.

could you send me your debug-info:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

just run that script on 2.6.23-rc2 system and send me the file it 
produces. I've got a theory about what might be going on, and this 
debug-info could help prove/disprove it.

	Ingo
