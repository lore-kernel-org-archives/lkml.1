Return-Path: <linux-kernel-owner+w=401wt.eu-S932614AbYEGTKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbYEGTKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbYEGTJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:09:49 -0400
Received: from www.tglx.de ([62.245.132.106]:56813 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757969AbYEGTJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:09:47 -0400
Date: Wed, 7 May 2008 21:08:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andres Salomon <dilinger@queued.net>
cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
In-Reply-To: <20080507114137.357aca34@ephemeral>
Message-ID: <alpine.LFD.1.10.0805072107200.3318@apollo.tec.linutronix.de>
References: <20080504193113.GA24358@elte.hu> <20080505151202.GA17139@cs181133002.pp.htv.fi> <20080505112917.7d4548fb@ephemeral> <alpine.LFD.1.10.0805061437430.3318@apollo.tec.linutronix.de> <20080507114137.357aca34@ephemeral>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Andres Salomon wrote:
> > Sorry, this should not have gone mainline. We had your patch queued
> > (via Andrew) and it had testing failures, which we sent to you. One
> > workaround was that build patch. When we dropped your patch we forgot
> > to remove the workaround as well.
> > 
> 
> Will it be removed, then?  I haven't seen any explanation of its
> benefits, and Adrian's point about not catching build failures in
> olpc_battery is valid.

Yes, it's scheduled for the next pull request. What's the state of the
build failures of your original patch ?

Thanks,
	tglx
