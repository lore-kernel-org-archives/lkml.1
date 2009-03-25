Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbZCYHU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbZCYHU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 03:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbZCYHUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 03:20:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941AbZCYHUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 03:20:16 -0400
Date: Wed, 25 Mar 2009 08:19:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 0/5] [PATCH][GIT PULL] remove unnecessary (un)likelys
Message-ID: <20090325071932.GA25833@elte.hu>
References: <20090325051920.406564281@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325051920.406564281@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I guess this can go through you. This is a start of clean ups to 
> get rid of (un)likelys that are at least 50% incorrect. This 
> series has some that are 100% incorrect.

Nice!

I'll wait for the acks from affected (and Cc:-ed) maintainers though 
- and they might decide to carry the patches in their trees straight 
away (or disagree with the change) so a rebase is in the cards as 
well.

	Ingo
