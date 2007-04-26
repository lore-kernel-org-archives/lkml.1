Return-Path: <linux-kernel-owner+w=401wt.eu-S933740AbXDZJTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740AbXDZJTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933751AbXDZJTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:19:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56065 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933740AbXDZJTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:19:49 -0400
Date: Thu, 26 Apr 2007 11:18:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070426091846.GA16631@elte.hu>
References: <20070425214704.GA32572@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425214704.GA32572@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> i'm pleased to announce release -v6 of the CFS scheduler patchset. The 
> main goal of CFS is to implement "high quality desktop scheduling" as 
> well as technically possible.
> 
> The CFS patch against v2.6.21-rc7 or against v2.6.20.7 can be 
> downloaded from the usual place:
> 
>     http://redhat.com/~mingo/cfs-scheduler/

i've also uploaded the -v6 patch against v2.6.21.

	Ingo
