Return-Path: <linux-kernel-owner+w=401wt.eu-S932769AbXGUGJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769AbXGUGJu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbXGUGJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:09:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:59655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbXGUGJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:09:41 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Date: Sat, 21 Jul 2007 08:09:38 +0200
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
References: <1184970779.4012.38.camel@chaos> <200707210737.59552.ak@suse.de> <Pine.LNX.4.58.0707210151020.29129@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0707210151020.29129@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707210809.38450.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > It's not really the same platform: one is PC hardware going back forever
> > with zillions of bugs, the other is modern PC platforms which much less
> > bugs and quirks
> 
> hehe, I'm seeing a bunch of bugs and quirks appear.  It's just that
> x86_64 isn't as old as i386 to have as many of them. But give it time.

It will always fundamentally always have less bugs and quirks than i386 because
it's much younger. Modern x86 is significantly different than traditional x86
and in the old days hardware wasn't really tested for the now modern interfaces,
so they tended to have a lot of bugs and quirks.

-Andi

