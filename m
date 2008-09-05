Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbYIEOzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbYIEOzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbYIEOzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:55:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39560 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbYIEOzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:55:41 -0400
Date: Fri, 5 Sep 2008 16:55:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, Andrew Morton <akpm@linux-foundation.org>,
       hpa@zytor.com, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: ticket spin lock adjustments
Message-ID: <20080905145519.GC10292@elte.hu>
References: <48C14174.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C14174.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> Re-sending the four patches previously sent individually as a series
> that would apply (a) to tip of linux-x86 and (b) on top of one another.
> 
> 1: fix asm constraints
> (formerly 2: use LOCK_PREFIX - no longer necessary)
> 2: factor out more common code
> 3: reduce instruction dependencies
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

applied to tip/x86/spinlocks - thanks Jan!

	Ingo
