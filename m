Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbXDOQ02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbXDOQ02 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 12:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbXDOQ02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 12:26:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36228 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbXDOQ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 12:26:27 -0400
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
	Scheduler [CFS]
From: Arjan van de Ven <arjan@infradead.org>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070415083616.GA29878@gnuppy.monkey.org>
References: <20070413202100.GA9957@elte.hu>
	 <200704151327.13589.kernel@kolivas.org>
	 <1176619384.6222.70.camel@Homer.simpson.net>
	 <20070415083616.GA29878@gnuppy.monkey.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 15 Apr 2007 09:25:07 -0700
Message-Id: <1176654307.3945.50.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> It outlines the problems with Linux kernel development and questionable
> elistism regarding ownership of certain sections of the kernel code.

I have to step in and disagree here....

Linux is not about who writes the code.

Linux is about getting the best solution for a problem. Who wrote which
line of the code is irrelevant in the big picture.

that often means that multiple implementations happen, and that the a
darwinistic process decides that the best solution wins.

This darwinistic process often happens in the form of discussion, and
that discussion can happen with words or with code. In this case it
happened with a code proposal.

To make this specific: it has happened many times to me that when I
solved an issue with code, someone else stepped in and wrote a different
solution (although that was usually for smaller pieces). Was I upset
about that? No! I was happy because my *problem got solved* in the best
possible way.

Now this doesn't mean that people shouldn't be nice to each other, not
cooperate or steal credits, but I don't get the impression that that is
happening here. Ingo is taking part in the discussion with a counter
proposal for discussion *on the mailing list*. What more do you want??
If you or anyone else can improve it or do better, take part of this
discussion and show what you mean either in words or in code.

Your qualification of the discussion as a elitist takeover... I disagree
with that. It's a *discussion*. Now if you agree that Ingo's patch is
better technically, you and others should be happy about that because
your problem is getting solved better. If you don't agree that his patch
is better technically, take part in the technical discussion.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

