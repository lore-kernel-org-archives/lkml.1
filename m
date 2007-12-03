Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbXLCRY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbXLCRY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 12:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbXLCRYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 12:24:22 -0500
Received: from www.tglx.de ([62.245.132.106]:56184 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbXLCRYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 12:24:22 -0500
Date: Mon, 3 Dec 2007 18:22:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Markus Metzger <markus.t.metzger@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Michael Kerrisk <mtk-manpages@gmx.net>, markus.t.metzger@gmail.com
Subject: Re: [patch 0/2] x86, ptrace: support for branch trace store(BTS)
In-Reply-To: <p73ir3fwvo2.fsf@bingen.suse.de>
Message-ID: <alpine.LFD.0.9999.0712031818100.4514@localhost.localdomain>
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com> <20071201074044.GA13974@elte.hu> <a430082a0712030553v22e9b46bnb9da975a23b1c0db@mail.gmail.com> <200712031721.39013.ak@suse.de> <20071203164506.GA16135@elte.hu>
 <p73ir3fwvo2.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007, Andi Kleen wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * Andi Kleen <ak@suse.de> wrote:
> >
> >> Just don't wait for that. utrace doesn't seem to have any concrete 
> >> plans to merge any time soon AFAIK[1] and it would be a shame to delay 
> >> an useful feature forever.
> >> 
> >> [1] At least the patches have not reached any mailing lists
> >
> > FYI, as far as arch/x86 goes, the merging of Roland's utrace preparatory 
> > patches is well underway in x86.git, and the merge went pretty well so 
> > far, with robust results. It's 49 patches so far:
> 
> I see. They are planning to just skip the public review stage?  Clever.

Andi,

stop that bullshit! Care to read what others write and check out your
LKML folder before barking ?

We got Rolands _PREPARATORY_ patches from LKML.

     tglx
