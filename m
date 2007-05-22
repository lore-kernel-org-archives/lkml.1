Return-Path: <linux-kernel-owner+w=401wt.eu-S933082AbXEVKOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbXEVKOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 06:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765057AbXEVKOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 06:14:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52177 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762776AbXEVKOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 06:14:40 -0400
Date: Tue, 22 May 2007 12:14:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pranith Kumar D <pranith-kumar_d@mentor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CFS: sched-design-CFS.txt - ambiguity about leftmost and some formatting
Message-ID: <20070522101437.GA32528@elte.hu>
References: <465292B0.8040604@mentorg.com> <20070522083051.GA9699@elte.hu> <4652B7B6.4080002@mentorg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4652B7B6.4080002@mentorg.com>
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


* Pranith Kumar D <pranith-kumar_d@mentor.com> wrote:

> The document is very clear and explains the basic mechanism of CFS 
> very well. But, i find that the descriptions are a bit up and down. I 
> mean, u use leftmost and rightmost before mentioning that CFS uses 
> rbtree.( which comes much later).
> 
> In the following patch I mentioned the rbtree, the first time you 
> talked about 'leftmost'. Also i did some basic formatting. Hope its 
> not a pain. :)

thanks - but the patch is whitespace damaged and wont apply:

patch: **** malformed patch at line 10: 80% of CFS's design can be 

that's because the leading space got stripped by your mailer.

	Ingo
