Return-Path: <linux-kernel-owner+w=401wt.eu-S937399AbXGTWiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937399AbXGTWiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbXGTWis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:38:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55903 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbXGTWir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:38:47 -0400
Message-ID: <46A1396F.4090204@garzik.org>
Date: Fri, 20 Jul 2007 18:38:39 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
References: <1184970779.4012.38.camel@chaos>
In-Reply-To: <1184970779.4012.38.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I agree with Andi...  it's quite nice to be able to leave some arch/i386 
stuff, and not carry it over to arch/x86-64.

	Jeff



