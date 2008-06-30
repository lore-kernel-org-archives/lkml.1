Return-Path: <linux-kernel-owner+w=401wt.eu-S1763243AbYF3SFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763243AbYF3SFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYF3SFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:05:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59501 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbYF3SFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:05:24 -0400
Date: Mon, 30 Jun 2008 20:03:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, heiko.carstens@de.ibm.com
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080630180342.GB23739@elte.hu>
References: <20080630153124.GA21919@elte.hu> <20080630173940.GA6133@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630173940.GA6133@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0026]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> Ingo,
> 
> You might want to put this is as a candidate for stable. I recall 
> seeing a similar crash in 2.6.24 rt as well. And Heiko mentioned 
> bisection taking him to 2.6.23

yep, i've bounced it to stable already and Greg has queued it up.

	Ingo
