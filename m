Return-Path: <linux-kernel-owner+w=401wt.eu-S1030839AbXDMVkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030839AbXDMVkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030842AbXDMVkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:40:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55074 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030839AbXDMVkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:40:01 -0400
Date: Fri, 13 Apr 2007 23:39:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070413213946.GA29617@elte.hu>
References: <20070413202100.GA9957@elte.hu> <20070413202745.GA17993@gnuppy.monkey.org> <20070413205545.GA18032@elte.hu> <20070413212110.GU2986@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413212110.GU2986@holomorphy.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* William Lee Irwin III <wli@holomorphy.com> wrote:

> What I originally did did so for a good reason, which was that it was 
> intended to support far more radical reorganizations, for instance, 
> things that changed the per-cpu runqueue affairs for gang scheduling. 
> I wrote a top-level driver that did support scheduling classes in a 
> similar fashion, though it didn't survive others maintaining the 
> patches.

yeah - i looked at plugsched-6.5-for-2.6.20.patch in particular.

	Ingo
