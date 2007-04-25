Return-Path: <linux-kernel-owner+w=401wt.eu-S2993006AbXDYToa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993006AbXDYToa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992996AbXDYToZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:44:25 -0400
Received: from mail1.panix.com ([166.84.1.72]:52334 "EHLO mail1.panix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992973AbXDYToF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:44:05 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2007 15:44:05 EDT
Date: Wed, 25 Apr 2007 12:43:58 -0700 (PDT)
From: Kenneth Crudup <kenny@panix.com>
To: Pavel Machek <pavel@ucw.cz>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070425072350.GA6866@ucw.cz>
Message-ID: <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
References: <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu>
 <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu>
 <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu>
 <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Apr 2007, Pavel Machek wrote:

> I'm starting to think that we should fix the idle power consumption
> problem. Cell phones do it right. They pretend to be ready/idle all
> the time, yet they have _days_ of standby.

My laptop goes nearly everywhere I do; I DO NOT want it on when I'm
travelling around to clients or between home and office or on a plane,
and I lose a lot of productivity the times I have to restart from a
cold boot as when I'm working I tend to have up ~10 xterms and while
my browsers have "restart", that's not infallible.

Any working suspend-to-disk method takes care of that for me.  (I'm
really not sure why Linus hates S2D so much, though. Back in the day
there was a lot more BIOS support, but that's been years now.)

	-Kenny

-- 
Kenneth R. Crudup  Sr. SW Engineer, Scott County Consulting, Los Angeles
O: 3630 S. Sepulveda Blvd. #138, L.A., CA 90034-6809      (888) 454-8181
