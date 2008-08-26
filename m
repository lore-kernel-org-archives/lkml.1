Return-Path: <linux-kernel-owner+w=401wt.eu-S1757746AbYHZJbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbYHZJbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 05:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYHZJbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 05:31:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37500 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbYHZJbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 05:31:24 -0400
Date: Tue, 26 Aug 2008 11:30:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Message-ID: <20080826093059.GA471@elte.hu>
References: <20080819103301.787700742@chello.nl> <20080819125954.GA20210@elte.hu> <200808202156.05024.nickpiggin@yahoo.com.au> <200808261900.07383.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808261900.07383.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> So... no reply to this? I'm really wondering how it's OK to break 
> documented standards and previous Linux behaviour by default for 
> something that it is trivial to solve in userspace? [...]

I disagree and what do you mean by "trivial to solve in user-space"?

	Ingo
