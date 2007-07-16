Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbXGPIBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbXGPIBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 04:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbXGPIB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 04:01:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50569 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbXGPIB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 04:01:26 -0400
Date: Mon, 16 Jul 2007 10:00:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Ed Tomlinson <edt@aei.ca>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070716080052.GA12245@elte.hu>
References: <20070706173319.GA2356@elte.hu> <200707141319.13270.edt@aei.ca> <1184477133.6378.21.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184477133.6378.21.camel@Homer.simpson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> Sending a few seconds of logged /proc/sched_debug will also help get a 
> picture of what's happening, and lovely would be a method to reproduce 
> the problem locally.

also, by running this script:

   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

and sending us the file it produces we'll have most of the environmental 
information as well.

	Ingo
