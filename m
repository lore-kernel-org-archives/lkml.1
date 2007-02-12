Return-Path: <linux-kernel-owner+w=401wt.eu-S964907AbXBLN0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964907AbXBLN0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 08:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964912AbXBLN0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 08:26:10 -0500
Received: from raven.upol.cz ([158.194.120.4]:39617 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964907AbXBLN0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 08:26:09 -0500
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <ak@muc.de>,
       virtualization@lists.osdl.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [q] kbuild for private asm-offsets (Re: [PATCH 6/10] lguest code: the little linux hypervisor.)
In-Reply-To: <1171034599.2718.190.camel@localhost.localdomain>
References: <1171012296.2718.26.camel@localhost.localdomain> <1171012761.2718.40.camel@localhost.localdomain> <1171012827.2718.42.camel@localhost.localdomain> <200702091109.20061.ak@muc.de> <1171024771.2718.129.camel@localhost.localdomain> <20070209141728.GA26749@uranus.ravnborg.org> <1171034599.2718.190.camel@localhost.localdomain>
Date: Mon, 12 Feb 2007 14:34:19 +0100
Message-Id: <E1HGbJz-0003Lc-6h@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rusty Russell
> Newsgroups: gmane.linux.kernel,gmane.linux.kernel.virtualization
> Subject: Re: [PATCH 6/10] lguest code: the little linux hypervisor.
> Date: Sat, 10 Feb 2007 02:23:19 +1100

Hallo, Rusty, guys.

> On Fri, 2007-02-09 at 15:17 +0100, Sam Ravnborg wrote:
>> I do not quite see what you ask for.
>> Care to try to describe the problem a bit then I may look at it sometime.
>> 
>> [Heading for vacation in a few hours so no prompt reply]
>
> I'd like my own, private "asm-offsets.h".  In this case, in
> arch/i386/lguest/.  I guess it's a matter of extracting the core of the
> asm-offsets.h magic and generalizing it.
>
> Have a good break!
> Rusty.

If you will have time for newbie, to explain in a few words, what is it need
for (whole idea, or key detail), and, maybe, why it is generated so ... interestingly:

            asm-offsets.c -> *.s -> *.h
 (but this looks like interconnecting C and assembler, obviously)

I will glad to help providing solution maybe somewhat earlier (well, i'm
trying to understand whole building process, if that matters).

.... And, of course, if this q isn't dumb.

Thanks.
____
