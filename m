Return-Path: <linux-kernel-owner+w=401wt.eu-S939015AbXGTXtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939015AbXGTXtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761677AbXGTXti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:49:38 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36168 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751608AbXGTXth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:49:37 -0400
Date: Sat, 21 Jul 2007 00:55:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Message-ID: <20070721005512.3db5fd77@the-village.bc.nu>
In-Reply-To: <46A1396F.4090204@garzik.org>
References: <1184970779.4012.38.camel@chaos>
	<46A1396F.4090204@garzik.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 18:38:39 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> I agree with Andi...  it's quite nice to be able to leave some arch/i386 
> stuff, and not carry it over to arch/x86-64.

Its easy enough to push that stuff into arch/x86/legacy and have one
subdirectory of stuff to pull in for ancient systems.

Alan
