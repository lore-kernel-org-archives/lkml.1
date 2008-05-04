Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYEDJYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYEDJYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 05:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbYEDJYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 05:24:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35116 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbYEDJYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 05:24:38 -0400
Date: Sun, 4 May 2008 11:24:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "akpm@osdl.org" <akpm@osdl.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] default to n for GROUP_SCHED and FAIR_GROUP_SCHED
Message-ID: <20080504092417.GA3425@elte.hu>
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Parag Warudkar <parag.warudkar@gmail.com> wrote:

> GROUP_SCHED is confirmed to cause unacceptable latencies -
> http://lkml.org/lkml/2008/5/2/370.

fixes for that are queued up in sched-devel:

   http://people.redhat.com/mingo/sched-devel.git/README

could you test whether that works any better for you?

	Ingo
