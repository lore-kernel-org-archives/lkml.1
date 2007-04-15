Return-Path: <linux-kernel-owner+w=401wt.eu-S1752233AbXDONIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbXDONIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 09:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbXDONIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 09:08:12 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46497 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbXDONIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 09:08:11 -0400
Date: Sun, 15 Apr 2007 16:08:08 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Willy Tarreau <w@1wt.eu>
cc: hui Bill Huey <billh@gnuppy.monkey.org>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070415124527.GP943@1wt.eu>
Message-ID: <Pine.LNX.4.64.0704151604520.7215@sbz-30.cs.Helsinki.FI>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org>
 <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu>
 <20070415095146.GA30327@gnuppy.monkey.org> <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com>
 <20070415124527.GP943@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Apr 2007, Willy Tarreau wrote:
> Ingo could have publicly spoken with them about his ideas of killing
> the O(1) scheduler and replacing it with an rbtree-based one, and using
> part of Bill's work to speed up development.

He did exactly that and he did it with a patch. Nothing new here. This is 
how development on LKML proceeds when you have two or more competing 
designs. There's absolutely no need to get upset or hurt your feelings 
over it. It's not malicious, it's how we do Linux development.
