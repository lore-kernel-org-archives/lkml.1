Return-Path: <linux-kernel-owner+w=401wt.eu-S1763414AbXGUFvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763414AbXGUFvx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 01:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbXGUFvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 01:51:46 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:64588 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbXGUFvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 01:51:45 -0400
Date: Sat, 21 Jul 2007 01:50:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <ak@suse.de>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
In-Reply-To: <200707210740.19227.ak@suse.de>
Message-ID: <Pine.LNX.4.58.0707210147340.29129@gandalf.stny.rr.com>
References: <1184970779.4012.38.camel@chaos>
 <6bffcb0e0707201655q664202e6v29b4e678de1b0d80@mail.gmail.com>
 <200707210740.19227.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> On Saturday 21 July 2007 01:55, Michal Piotrowski wrote:
> >
> > I really like this idea - code duplication is a bad thing.
>
> Did you actually look at the patch? It doesn't have a single line
> less duplication than there was before. Everything that could
> be easily shared was shared already.
>
> It's just new window dressing without any real advantages.

And did you read what tglx wrote?

This patch was the beginning of the merger, not the end result. It strived
for binary identical images. It was to put everything together as a
_starting_point_!   The next thing to do after this is to start the
merging.

-- Steve

