Return-Path: <linux-kernel-owner+w=401wt.eu-S937664AbXGTWlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937664AbXGTWlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbXGTWk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:40:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60855 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbXGTWk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:40:58 -0400
Date: Sat, 21 Jul 2007 00:40:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Message-ID: <20070720224033.GA12358@elte.hu>
References: <1184970779.4012.38.camel@chaos> <46A1396F.4090204@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A1396F.4090204@garzik.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> I agree with Andi...  it's quite nice to be able to leave some 
> arch/i386 stuff, and not carry it over to arch/x86-64.

we can leave those few items in arch/x86 just as much. No need to keep 
around a legacy tree for that.

	Ingo
