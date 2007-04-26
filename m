Return-Path: <linux-kernel-owner+w=401wt.eu-S1031472AbXDZUKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031472AbXDZUKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031498AbXDZUKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:10:37 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:44541 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031472AbXDZUKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:10:36 -0400
Subject: Re: [patch] CFS scheduler, -v6
From: Kasper Sandberg <lkml@metanurb.dk>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
In-Reply-To: <200704261041.04838.gene.heskett@gmail.com>
References: <20070425214704.GA32572@elte.hu>
	 <1177596399.14496.1.camel@localhost>
	 <200704261041.04838.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 22:09:24 +0200
Message-Id: <1177618164.14496.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 10:41 -0400, Gene Heskett wrote:
<snip>
> 
> Compared to mainline?  I still think this is a 100% keeper for desktop users 
> like me.

Here its alot worse, just playing an ogg with ogg123 even without
anything reniced (X is 0), just pressing a link in konqueror can make
audio skip (ogg123 fails to fill the alsa buffer, and thus it skips).
this is something that simply does not happen for me on vanilla,
staircase or SD.

it just doesent seem to work properly..

