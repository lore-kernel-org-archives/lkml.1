Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbYFILsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbYFILsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 07:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759454AbYFILsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 07:48:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45364 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759266AbYFILsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 07:48:09 -0400
Date: Mon, 9 Jun 2008 13:47:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] introduce signal_pending_state()
Message-ID: <20080609114739.GA14800@elte.hu>
References: <20080604170904.GA10270@tv-sign.ru> <20080609114513.GC5028@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609114513.GC5028@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > The second patch is just an example of how the new helper can be 
> > used (besides for schedule).
> 
> applied to tip/urgent, thanks. (and disregard my previous mail about 
> which patch to try ;-)

... and i updated the patch to yesterday's fixed version.

	Ingo
