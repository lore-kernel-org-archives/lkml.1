Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbXKBPd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbXKBPd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbXKBPdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:33:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40600 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbXKBPds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:33:48 -0400
Date: Fri, 2 Nov 2007 16:33:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Gregory Haskins <gregory.haskins.ml@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
Message-ID: <20071102153332.GA28575@elte.hu>
References: <20071101140146.GA26879@wotan.suse.de> <20071101140320.GC26879@wotan.suse.de> <4729E567.1050402@gmail.com> <alpine.LFD.0.999.0711010935060.3342@woody.linux-foundation.org> <20071101203526.293cd7f0@bree.surriel.com> <alpine.LFD.0.999.0711011819110.3342@woody.linux-foundation.org> <20071102064220.GC20967@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102064220.GC20967@wotan.suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
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


* Nick Piggin <npiggin@suse.de> wrote:

> Anyway, if this can make its way to the x86 tree, I think it will get 
> pulled into -mm (?) and get some exposure...

ok, we can certainly try it there. Your code is really nifty.

	Ingo
