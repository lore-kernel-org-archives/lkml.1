Return-Path: <linux-kernel-owner+w=401wt.eu-S937677AbXGUIdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937677AbXGUIdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 04:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760971AbXGUIda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 04:33:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36911 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbXGUId3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 04:33:29 -0400
Date: Sat, 21 Jul 2007 10:32:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Adrian Bunk <bunk@stusta.de>, Steven Rostedt <rostedt@goodmis.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Message-ID: <20070721083251.GA373@elte.hu>
References: <1184970779.4012.38.camel@chaos> <200707210806.12880.ak@suse.de> <20070721073533.GE3801@stusta.de> <200707210942.48444.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707210942.48444.ak@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> > It happens so often that someone accidentally breaks one 
> > architecture because he didn't notice the code also gets used on the 
> > other architecture.
> 
> That's not changing at all. Especially with even more sharing, (than I 
> think would be prudent) like Thomas treated, you'll likely have to 
> test compile both for most changes.

yes, very much so, and that's exactly one of our points.

	Ingo
