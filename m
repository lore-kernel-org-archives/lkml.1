Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbYHRGWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbYHRGWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 02:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYHRGWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 02:22:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41600 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbYHRGWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 02:22:33 -0400
Date: Mon, 18 Aug 2008 08:22:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [git pull] core fixes
Message-ID: <20080818062218.GA1755@elte.hu>
References: <20080811222026.GA20579@elte.hu> <200808141445.03936.nickpiggin@yahoo.com.au> <20080815125818.GA30597@elte.hu> <200808181522.50563.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808181522.50563.nickpiggin@yahoo.com.au>
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

> You didn't at all point to any *upsides* of your merging in this way, 
> so I assume there are none?

ah, i think i see where the confusion comes from. I assumed you knew 
that by the time your corrected patch arrived i already sent my pull 
request to Linus [having tested it and having found no immediate 
problems with it] and Linus already merged it?

So i did a delta patch and sent a second pull request, with a second 
branch. No puppies got hurt in the process as the two commits are close 
to each other and werent in fact pushed out by Linus separately.

Obviously you are right in the general case and we try to avoid 
splitting up fixes into two parts when possible.

	Ingo
