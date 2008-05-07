Return-Path: <linux-kernel-owner+w=401wt.eu-S932957AbYEGTol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbYEGTol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYEGToa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:44:30 -0400
Received: from mail.queued.net ([207.210.101.209]:4674 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbYEGTo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:44:29 -0400
Date: Wed, 7 May 2008 15:48:18 -0400
From: Andres Salomon <dilinger@queued.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080507154818.5f22f8e0@ephemeral>
In-Reply-To: <alpine.LFD.1.10.0805072107200.3318@apollo.tec.linutronix.de>
References: <20080504193113.GA24358@elte.hu>
	<20080505151202.GA17139@cs181133002.pp.htv.fi>
	<20080505112917.7d4548fb@ephemeral>
	<alpine.LFD.1.10.0805061437430.3318@apollo.tec.linutronix.de>
	<20080507114137.357aca34@ephemeral>
	<alpine.LFD.1.10.0805072107200.3318@apollo.tec.linutronix.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008 21:08:40 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 7 May 2008, Andres Salomon wrote:
> > > Sorry, this should not have gone mainline. We had your patch
> > > queued (via Andrew) and it had testing failures, which we sent to
> > > you. One workaround was that build patch. When we dropped your
> > > patch we forgot to remove the workaround as well.
> > > 
> > 
> > Will it be removed, then?  I haven't seen any explanation of its
> > benefits, and Adrian's point about not catching build failures in
> > olpc_battery is valid.
> 
> Yes, it's scheduled for the next pull request. What's the state of the
> build failures of your original patch ?
> 
> Thanks,
> 	tglx


They're queued up in Andrew's tree, I believe.  You were also CC'd;
Message-ID: <20080504104756.3d7b6842@ephemeral>.  It wasn't CC'd to
lkml, unfortunately.

