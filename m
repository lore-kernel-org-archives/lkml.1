Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbXDPL7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbXDPL7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 07:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbXDPL7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 07:59:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51720 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbXDPL7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 07:59:09 -0400
Date: Mon, 16 Apr 2007 13:58:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070416115854.GA27566@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704160149.42914.ismail@pardus.org.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704160149.42914.ismail@pardus.org.tr>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ismail Dönmez <ismail@pardus.org.tr> wrote:

> Tested this on top of Linus' GIT tree but the system gets very 
> unresponsive during high disk i/o using ext3 as filesystem but even 
> writing a 300mb file to a usb disk (iPod actually) has the same 
> affect.

hm. Is this an SMP system+kernel by any chance?

	Ingo
