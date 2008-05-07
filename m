Return-Path: <linux-kernel-owner+w=401wt.eu-S1762602AbYEGUKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762602AbYEGUKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYEGUKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:10:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753986AbYEGUKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:10:23 -0400
Date: Wed, 7 May 2008 13:07:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: tglx@linutronix.de, bunk@kernel.org, mingo@elte.hu,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [git pull] x86 fixes
Message-Id: <20080507130725.eb03f490.akpm@linux-foundation.org>
In-Reply-To: <20080507154818.5f22f8e0@ephemeral>
References: <20080504193113.GA24358@elte.hu>
	<20080505151202.GA17139@cs181133002.pp.htv.fi>
	<20080505112917.7d4548fb@ephemeral>
	<alpine.LFD.1.10.0805061437430.3318@apollo.tec.linutronix.de>
	<20080507114137.357aca34@ephemeral>
	<alpine.LFD.1.10.0805072107200.3318@apollo.tec.linutronix.de>
	<20080507154818.5f22f8e0@ephemeral>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008 15:48:18 -0400
Andres Salomon <dilinger@queued.net> wrote:

> On Wed, 7 May 2008 21:08:40 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Wed, 7 May 2008, Andres Salomon wrote:
> > > > Sorry, this should not have gone mainline. We had your patch
> > > > queued (via Andrew) and it had testing failures, which we sent to
> > > > you. One workaround was that build patch. When we dropped your
> > > > patch we forgot to remove the workaround as well.
> > > > 
> > > 
> > > Will it be removed, then?  I haven't seen any explanation of its
> > > benefits, and Adrian's point about not catching build failures in
> > > olpc_battery is valid.
> > 
> > Yes, it's scheduled for the next pull request. What's the state of the
> > build failures of your original patch ?
> > 
> > Thanks,
> > 	tglx
> 
> 
> They're queued up in Andrew's tree, I believe.  You were also CC'd;
> Message-ID: <20080504104756.3d7b6842@ephemeral>.  It wasn't CC'd to
> lkml, unfortunately.

These?

x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
x86-geode-define-geode_has_vsa2-even-if-config_mgeode_lx-is-not-set.patch

I have them queued up as for-git-x86.  I'll send them over..
