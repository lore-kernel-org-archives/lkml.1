Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbXJQSVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbXJQSVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757685AbXJQSV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:21:27 -0400
Received: from www.tglx.de ([62.245.132.106]:44264 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757657AbXJQSV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:21:27 -0400
Date: Wed, 17 Oct 2007 20:21:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] paravirt_ops and xen updates for 2.6.24
In-Reply-To: <20071017180626.GA9307@elte.hu>
Message-ID: <alpine.LFD.0.9999.0710172020200.24155@localhost.localdomain>
References: <47150D5E.6090504@goop.org> <47164C89.60400@goop.org> <20071017180626.GA9307@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > > Hi Linus,
> > >   
> > 
> > Ping?
> > 
> > > Please pull:
> > >
> > >   ssh://master.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen-upstream
> > >
> > > This contains updates for arch/x86 paravirt_ops and Xen.
> 
> hm, could we do the arch/x86 changes via the arch/x86 tree instead? 
> We've got about a 100 patches pending there now, under QA, preparing 
> them for pushout. Will check your paravirt patches too, ok?

Yeah, I'm fixing merge conflicts the third time today :)

      tglx
