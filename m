Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbXD0EDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbXD0EDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 00:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbXD0EDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 00:03:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:48222 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755260AbXD0EDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 00:03:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/E9bgC+UPEMYzQiduNuF99LDhzD7u6W9AS7HdaQc
	oEcX/pZSx4bvp/
Subject: Re: [patch] CFS scheduler, -v6
From: Mike Galbraith <efault@gmx.de>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Gene Heskett <gene.heskett@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
In-Reply-To: <1177618164.14496.5.camel@localhost>
References: <20070425214704.GA32572@elte.hu>
	 <1177596399.14496.1.camel@localhost>
	 <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 06:02:52 +0200
Message-Id: <1177646573.6520.4.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 22:09 +0200, Kasper Sandberg wrote:
> On Thu, 2007-04-26 at 10:41 -0400, Gene Heskett wrote:
> <snip>
> > 
> > Compared to mainline?  I still think this is a 100% keeper for desktop users 
> > like me.
> 
> Here its alot worse, just playing an ogg with ogg123 even without
> anything reniced (X is 0), just pressing a link in konqueror can make
> audio skip (ogg123 fails to fill the alsa buffer, and thus it skips).

What arguments are you passing to ogg123?  I'm creating some ogg files
right now, and would like to reproduce these skips to see why they're
happening if possible.

	-Mike

