Return-Path: <linux-kernel-owner+w=401wt.eu-S938541AbXGTWnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938541AbXGTWnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbXGTWmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:42:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55954 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034AbXGTWmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:42:46 -0400
Message-ID: <46A13A62.5020502@garzik.org>
Date: Fri, 20 Jul 2007 18:42:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
References: <1184970779.4012.38.camel@chaos> <46A1396F.4090204@garzik.org> <20070720224033.GA12358@elte.hu>
In-Reply-To: <20070720224033.GA12358@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
>> I agree with Andi...  it's quite nice to be able to leave some 
>> arch/i386 stuff, and not carry it over to arch/x86-64.
> 
> we can leave those few items in arch/x86 just as much. No need to keep 
> around a legacy tree for that.

By extension it makes doing that sort of thing, in general, more 
difficult.  Which is IMO not desirable.

	Jeff



