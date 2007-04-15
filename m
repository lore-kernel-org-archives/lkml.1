Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbXDOTFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbXDOTFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 15:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbXDOTFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 15:05:41 -0400
Received: from lollipop.listbox.com ([208.210.124.78]:36490 "EHLO
	lollipop.listbox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbXDOTFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 15:05:40 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Apr 2007 15:05:40 EDT
In-Reply-To: <Pine.LNX.4.64.0704151054080.5473@woody.linux-foundation.org>
References: <20070413202100.GA9957@elte.hu>  <200704151327.13589.kernel@kolivas.org> <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu> <20070415095146.GA30327@gnuppy.monkey.org>  <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com>  <20070415124527.GP943@1wt.eu>  <Pine.LNX.4.64.0704151604520.7215@sbz-30.cs.Helsinki.FI> <1176658335.6364.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0704151054080.5473@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6741477B-4621-4A50-952E-0D03260D9526@lundell-bros.com>
Cc: Mike Galbraith <efault@gmx.de>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Willy Tarreau <w@1wt.eu>, hui Bill Huey <billh@gnuppy.monkey.org>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Peter Williams <pwil3058@bigpond.net.au>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Transfer-Encoding: 7bit
From: Jonathan Lundell <linux@lundell-bros.com>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Sun, 15 Apr 2007 12:00:15 -0700
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 15, 2007, at 10:59 AM, Linus Torvalds wrote:

> It's a really good thing, and it means that if somebody shows that  
> your
> code is flawed in some way (by, for example, making a patch that  
> people
> claim gets better behaviour or numbers), any *good* programmer that
> actually cares about his code will obviously suddenly be very  
> motivated to
> out-do the out-doer!

"No one who cannot rejoice in the discovery of his own mistakes  
deserves to be called a scholar."

--Don Foster, "literary sleuth", on retracting his attribution of "A  
Funerall Elegye" to Shakespeare (it's more likely John Ford's work).
