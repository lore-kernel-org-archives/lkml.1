Return-Path: <linux-kernel-owner+w=401wt.eu-S934267AbXJQUQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934267AbXJQUQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760874AbXJQUQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:16:07 -0400
Received: from www.tglx.de ([62.245.132.106]:54223 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757300AbXJQUQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:16:04 -0400
Date: Wed, 17 Oct 2007 22:15:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] paravirt_ops and xen updates for 2.6.24
In-Reply-To: <47165444.30208@goop.org>
Message-ID: <alpine.LFD.0.9999.0710172213510.24155@localhost.localdomain>
References: <47150D5E.6090504@goop.org> <47164C89.60400@goop.org> <20071017180626.GA9307@elte.hu> <47165444.30208@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, Jeremy Fitzhardinge wrote:

> Ingo Molnar wrote:
> > hm, could we do the arch/x86 changes via the arch/x86 tree instead? 
> > We've got about a 100 patches pending there now, under QA, preparing 
> > them for pushout. Will check your paravirt patches too, ok?
> 
> Yep, that's fine.

I just pulled your tree on top of my tip and there are no conflicts. I
checked the diffs and there is nothing, which is conflicting with our
backlogs.

Linus, please go ahead and pull it yourself.

Thanks,

	tglx
