Return-Path: <linux-kernel-owner+w=401wt.eu-S935873AbXGUADe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935873AbXGUADe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 20:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbXGUADY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 20:03:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38744 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbXGUADX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 20:03:23 -0400
Date: Sat, 21 Jul 2007 02:03:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Message-ID: <20070721000309.GA24829@elte.hu>
References: <1184970779.4012.38.camel@chaos> <6bffcb0e0707201655q664202e6v29b4e678de1b0d80@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0707201655q664202e6v29b4e678de1b0d80@mail.gmail.com>
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


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> >We are pleased to announce a project we've been working on for some 
> >time: the unified x86 architecture tree, or "arch/x86" - and we'd 
> >like to solicit feedback about it.
> >
> >What is this about?
> [..]
> >As usual, comments and suggestions are welcome!
> 
> I really like this idea - code duplication is a bad thing.
> 
> BTW. I don't see any regression here :)

cool - could you tell us a bit more about on what type of box you tried 
it, and how wide and versatile the .config is?

	Ingo
