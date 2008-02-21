Return-Path: <linux-kernel-owner+w=401wt.eu-S933036AbYBUXQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036AbYBUXQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbYBUXQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:16:11 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:65246 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbYBUXQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:16:09 -0500
Date: Thu, 21 Feb 2008 18:10:37 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mark Hounschell <dmarkh@cfl.rr.com>
cc: Mark Hounschell <markh@compro.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: 2.6.24-rt1 IRQ routing anomaly
In-Reply-To: <47BDFE2C.208@cfl.rr.com>
Message-ID: <Pine.LNX.4.58.0802211809200.6392@gandalf.stny.rr.com>
References: <47BD6802.60604@cfl.rr.com> <Pine.LNX.4.58.0802210743080.9890@gandalf.stny.rr.com>
 <47BD7D09.9050106@compro.net> <Pine.LNX.4.58.0802211005380.9890@gandalf.stny.rr.com>
 <47BDFE2C.208@cfl.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 21 Feb 2008, Mark Hounschell wrote:
> >
> > Thanks for verifying. OK, I'll see if I can get the workaround on i386. I
> > thought I saw a patch someplace where someone ported that workaround. I'm
> > still sorting out bugs in -rt2 (why it is still not out). I'll see if I
> > can find time to get the workaround to i386 for -rt2 as well.
> >
> > -- Steve
>
> I'll be happy to test it for ya
>

I'm looking at it now, and it seems the work around is already there for
i386. I don't know why it didn't trigger for you.

Can you send me privately, a full dmesg and the output of lspci -vvv

Thanks,

-- Steve

