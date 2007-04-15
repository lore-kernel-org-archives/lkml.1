Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbXDORc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbXDORc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 13:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbXDORc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 13:32:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:36664 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753198AbXDORcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 13:32:19 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+iSIIetGqiqPvHonByeoyOCYMU5KD08yLY2QEJ66
	jVgbyYqCVpfoER
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
	Scheduler [CFS]
From: Mike Galbraith <efault@gmx.de>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Willy Tarreau <w@1wt.eu>, hui Bill Huey <billh@gnuppy.monkey.org>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Peter Williams <pwil3058@bigpond.net.au>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.64.0704151604520.7215@sbz-30.cs.Helsinki.FI>
References: <20070413202100.GA9957@elte.hu>
	 <200704151327.13589.kernel@kolivas.org>
	 <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu>
	 <20070415095146.GA30327@gnuppy.monkey.org>
	 <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com>
	 <20070415124527.GP943@1wt.eu>
	 <Pine.LNX.4.64.0704151604520.7215@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain
Date: Sun, 15 Apr 2007 19:32:15 +0200
Message-Id: <1176658335.6364.11.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-15 at 16:08 +0300, Pekka J Enberg wrote:
> On Sun, 15 Apr 2007, Willy Tarreau wrote:
> > Ingo could have publicly spoken with them about his ideas of killing
> > the O(1) scheduler and replacing it with an rbtree-based one, and using
> > part of Bill's work to speed up development.
> 
> He did exactly that and he did it with a patch. Nothing new here. This is 
> how development on LKML proceeds when you have two or more competing 
> designs. There's absolutely no need to get upset or hurt your feelings 
> over it. It's not malicious, it's how we do Linux development.

Yes.  Exactly.  This is what it's all about, this is what makes it work.

	-Mike

