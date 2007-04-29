Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbXD2KeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbXD2KeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbXD2KeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:34:13 -0400
Received: from holomorphy.com ([66.93.40.71]:50599 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbXD2KeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:34:12 -0400
Date: Sun, 29 Apr 2007 03:33:36 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429103336.GZ19966@holomorphy.com>
References: <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu> <1177842654.5791.85.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177842654.5791.85.camel@localhost.localdomain>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 12:30:54PM +0200, Thomas Gleixner wrote:
> Can we please stop this useless pissing contest and sit down and get a
> modular design into mainline, which allows folks to work and integrate
> their "workload X perfect scheduler" and gives us the flexibility to
> adjust to the needs of upcoming functionality.

If I don't see some sort of modularity patch soon I'll post one myself.


-- wli
