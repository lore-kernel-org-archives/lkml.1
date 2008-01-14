Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbYANNZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbYANNZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbYANNZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:25:07 -0500
Received: from mail.gmx.net ([213.165.64.20]:42194 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750838AbYANNZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:25:05 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX198iEgMmnF8SK9yjxKKPq+TTgQKXxqmkVg+SaXIWZ
	zr/quqSqs3kdY3
Subject: Re: 2.6.24-rc7-rt1
From: Mike Galbraith <efault@gmx.de>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
In-Reply-To: <478B0B7C.BA47.005A.0@novell.com>
References: <1200250801.9190.7.camel@localhost.localdomain>
	 <200801132143.34889.m.kozlowski@tuxland.pl>
	 <Pine.LNX.4.58.0801131552350.10093@gandalf.stny.rr.com>
	 <1200299260.4665.17.camel@homer.simson.net>
	 <478B0B7C.BA47.005A.0@novell.com>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 14:25:01 +0100
Message-Id: <1200317101.3733.14.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-14 at 07:13 -0500, Gregory Haskins wrote:
> >>> On Mon, Jan 14, 2008 at  3:27 AM, in message
> <1200299260.4665.17.camel@homer.simson.net>, Mike Galbraith <efault@gmx.de>
> wrote: 
> 
> > On Sun, 2008-01-13 at 15:54 -0500, Steven Rostedt wrote:
> > 
> >> OK, -rt2 will take a bit more beating from me before I release it, so it
> >> might take some time to get it out (expect it out on Monday).
> > 
> > Ah, that reminds me (tests, yup) I still need the patchlet below to
> > resume from ram without black screen of death.
> 
> I had forgotten about this issue over the holidays...Sorry Mike.

I forgot about it too.  I'll likely poke at it again.

> So does that BUG_ON trip if you remove the first hunk?

No, I just copied the matching paranoia while leering at it.

	-Mike

