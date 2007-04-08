Return-Path: <linux-kernel-owner+w=401wt.eu-S1750797AbXDHK7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750797AbXDHK7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 06:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbXDHK7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 06:59:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53967 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbXDHK7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 06:59:08 -0400
Date: Sun, 8 Apr 2007 12:58:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: Re: Ten percent test
Message-ID: <20070408105849.GA15764@elte.hu>
References: <200703290237.38777.kernel@kolivas.org> <200704071423.47790.gene.heskett@gmail.com> <20070407185220.GA31725@elte.hu> <200704071630.25830.gene.heskett@gmail.com> <20070408104125.GB11123@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070408104125.GB11123@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > My question then, is why did it take a very public cat-fight to get 
> > this looked at and the code adjusted?  Its been what, nearly 2 years 
> > since Linus himself made a comment that this thing needed fixed.  
> > The fixes then done were of very little actual effectiveness and the 
> > situation then has gradually deteriorated since.
> 
> this is pretty hard to get right, and the most objective way to change 
> it is to do it testcase-driven. FYI, interactivity tweaking has been 
> gradual, the last bigger round of interactivity changes were done a 
> year ago:

and note that a year ago Mike did a larger patch too, not unlike his 
current patch - but we hoped that his smaller change would be sufficient 
- and nobody came along and said "i tested Mike's and the difference is 
significant on my system". Which seems to suggest that the number of 
problem-systems and worried users/developers isnt particularly large.

	Ingo
