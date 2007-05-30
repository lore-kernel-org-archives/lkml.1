Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbXE3NZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbXE3NZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbXE3NZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:25:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44013 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665AbXE3NZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:25:07 -0400
Date: Wed, 30 May 2007 15:24:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Huey <billh@gnuppy.monkey.org>, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
Message-ID: <20070530132431.GA23947@elte.hu>
References: <20070529125248.877196281@chello.nl> <20070529130107.112347096@chello.nl> <1180470525.32594.71.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180470525.32594.71.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> [...] Most architecture implement a jiffies sched_clock() w/ 1 
> millisecond or worse resolution.. [...]

weird that you count importance by 'number of architectures', while 98% 
of the installed server base is x86 or x86_64, where sched_clock() is 
pretty precise ;-)

	Ingo
