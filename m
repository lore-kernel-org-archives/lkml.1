Return-Path: <linux-kernel-owner+w=401wt.eu-S1031401AbXD2Uaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031401AbXD2Uaf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031398AbXD2Uaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:30:35 -0400
Received: from rtr.ca ([64.26.128.89]:4992 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031395AbXD2Uae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:30:34 -0400
Message-ID: <46350068.6040800@rtr.ca>
Date: Sun, 29 Apr 2007 16:30:32 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
References: <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu> <1177842654.5791.85.camel@localhost.localdomain> <20070429111159.GH23638@1wt.eu>
In-Reply-To: <20070429111159.GH23638@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> ..
> Contrarily to most people, I don't see them as competitors. I see SD as
> a first step with a low risk of regression, and CFS as an ultimate
> solution relying on a more solid framework.

I see SD as 100% chance of regression on my main machine.

But I will retest (on Monday?) with the latest, just to see
if it has improved closer to mainline or not.

-ml
