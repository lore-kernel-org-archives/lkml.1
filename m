Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbXJXIEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbXJXIEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 04:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbXJXIEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 04:04:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57184 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbXJXIEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 04:04:08 -0400
Date: Wed, 24 Oct 2007 10:04:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux v2.6.24-rc1
Message-ID: <20071024080401.GA18882@elte.hu>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Just for fun, I'd really encourage git users to just try the
> 
> 	git shortlog v2.6.23..
> 
> thing, it really is quite impressive. 

what is also impressive is:

   $ git shortlog v2.6.23.. | grep \):$ | wc -l
   756

756 individual contributors. Wow!

	Ingo
