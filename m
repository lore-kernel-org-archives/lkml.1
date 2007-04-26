Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbXDZTEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbXDZTEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbXDZTEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:04:04 -0400
Received: from mail.tmr.com ([64.65.253.246]:47955 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbXDZTEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:04:00 -0400
Message-ID: <4630F7A6.3080609@tmr.com>
Date: Thu, 26 Apr 2007 15:04:06 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
References: <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424205416.GA23032@elte.hu> <20070424212956.GE16457@elf.ucw.cz> <20070425214156.GI11166@waste.org>
In-Reply-To: <20070425214156.GI11166@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Tue, Apr 24, 2007 at 11:29:56PM +0200, Pavel Machek wrote:
>> We do not want to fragment the testing base, and suspend2 does not
>> really have any interesting features over uswsusp.
> 
> The testing base is already fragmented!
> 
> What the current situation means is that you simply never hear from
> the people who get fed up with suspend but who manage to get suspend2
> working.
> 
I have to feel that having a *working resume* capability is "any 
interesting features" enough. What you say about "simply never hear 
from" is unfortunately true.

On 04/25/2007 05:30 PM EDT, Pavel Machek wrote:

 >It is not Rafael's fault. Actually it is quite hard to work with
 >Nigel, because he implements every feature someone asks for, and wants
 >to merge them all  :-( . I don't expect to ever agree with Nigel on
 >anything important, sorry.

The fact that Pavel thinks giving the users what they want is a problem 
certainly defines the difference between them, the populist "give them 
what they want" and the elitist "let's them make do with what I think 
they should have."

I do respect Pavel for all the stuff he has done and is doing, I wish I 
could have found a nicer way to say that.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
