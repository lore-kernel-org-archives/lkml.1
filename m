Return-Path: <linux-kernel-owner+w=401wt.eu-S936192AbXGUWOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936192AbXGUWOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935769AbXGUWNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:13:20 -0400
Received: from barikada.upol.cz ([158.194.242.200]:37635 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935750AbXGUWNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:13:17 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
In-Reply-To: <20070721005512.3db5fd77@the-village.bc.nu>
References: <1184970779.4012.38.camel@chaos> <46A1396F.4090204@garzik.org> <20070721005512.3db5fd77@the-village.bc.nu>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Sun, 22 Jul 2007 00:26:53 +0200
Message-Id: <E1ICNPZ-0000wQ-8G@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* From: Alan Cox
* Date: Sat, 21 Jul 2007 00:55:12 +0100
* Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
>
> On Fri, 20 Jul 2007 18:38:39 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
>
>> I agree with Andi...  it's quite nice to be able to leave some arch/i386 
>> stuff, and not carry it over to arch/x86-64.
>
> Its easy enough to push that stuff into arch/x86/legacy and have one
> subdirectory of stuff to pull in for ancient systems.

Or if i386 and virualization guys don't want to quietly break/mess with
stuff pulled by x86-64, move it to x86-64 instead. Elegant, easy, honors
Andi.
____
