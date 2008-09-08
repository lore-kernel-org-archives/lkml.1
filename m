Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYIHOcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYIHOcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYIHOcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:32:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36453 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbYIHOcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:32:11 -0400
Date: Mon, 8 Sep 2008 16:31:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@tglx.de, torvalds@linux-foundation.org,
       peterz@infradead.org
Subject: Re: update on hrtimer based select/poll and range-hrtimers
Message-ID: <20080908143150.GC10580@elte.hu>
References: <20080907111137.76a10b1e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080907111137.76a10b1e@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> Hi,
> 
> since the last lkml posting I've merged a few fixes and added comments
> from Peter, and I've redone the "estimate_accuracy" function.
> 
> Rather than reposting the entire series, I'll point to the git tree at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-hrtimer.git

pulled into tip/timers/range-hrtimers, thanks Arjan!

	Ingo
