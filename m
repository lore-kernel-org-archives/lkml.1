Return-Path: <linux-kernel-owner+w=401wt.eu-S935781AbXGUKh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935781AbXGUKh6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 06:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbXGUKhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 06:37:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58827 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbXGUKhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 06:37:50 -0400
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
From: David Woodhouse <dwmw2@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1184970779.4012.38.camel@chaos>
References: <1184970779.4012.38.camel@chaos>
Content-Type: text/plain
Date: Sat, 21 Jul 2007 11:37:46 +0100
Message-Id: <1185014266.14697.136.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-21 at 00:32 +0200, Thomas Gleixner wrote:
> We are pleased to announce a project we've been working on for some 
> time: the unified x86 architecture tree, or "arch/x86" - and we'd like
> to solicit feedback about it. 

Oooh, shiny. We've been talking about how useful this would be for
years. Experience with the unification of PowerPC shows that it's
definitely the right thing to do -- it reduces the number of gratuitous
differences between 32-bit and 64-bit code, and makes it far more easier
to ensure that bug-fixes and new features get added to both at the same
time.

> When should this go upstream?
> -----------------------------
> 
> We actually think that the sooner we get over with this, the better.

I'm inclined to agree.

-- 
dwmw2

