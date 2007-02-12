Return-Path: <linux-kernel-owner+w=401wt.eu-S965021AbXBLRYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965021AbXBLRYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 12:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965023AbXBLRYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 12:24:16 -0500
Received: from colin.muc.de ([193.149.48.1]:3244 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965021AbXBLRYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 12:24:16 -0500
Date: 12 Feb 2007 18:24:13 +0100
Date: Mon, 12 Feb 2007 18:24:13 +0100
From: Andi Kleen <ak@muc.de>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
       virtualization@lists.osdl.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [q] kbuild for private asm-offsets (Re: [PATCH 6/10] lguest code: the little linux hypervisor.)
Message-ID: <20070212172413.GA40274@muc.de>
References: <1171012296.2718.26.camel@localhost.localdomain> <1171012761.2718.40.camel@localhost.localdomain> <1171012827.2718.42.camel@localhost.localdomain> <200702091109.20061.ak@muc.de> <1171024771.2718.129.camel@localhost.localdomain> <20070209141728.GA26749@uranus.ravnborg.org> <1171034599.2718.190.camel@localhost.localdomain> <E1HGbJz-0003Lc-6h@flower>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HGbJz-0003Lc-6h@flower>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If you will have time for newbie, to explain in a few words, what is it need
> for (whole idea, or key detail), and, maybe, why it is generated so ... interestingly:
> 
>             asm-offsets.c -> *.s -> *.h
>  (but this looks like interconnecting C and assembler, obviously)
> 
> I will glad to help providing solution maybe somewhat earlier (well, i'm
> trying to understand whole building process, if that matters).

The problem is trying to figure out what needs to be done to get
multiple asm-offsets.h.

-Andi
