Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbYGOWO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbYGOWO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbYGOWOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:14:45 -0400
Received: from www.tglx.de ([62.245.132.106]:49109 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbYGOWOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:14:44 -0400
Date: Wed, 16 Jul 2008 00:14:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] x86 updates
In-Reply-To: <20080715220547.GA11448@elte.hu>
Message-ID: <alpine.LFD.1.10.0807160011400.3283@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0807152249270.3283@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807151417440.2867@woody.linux-foundation.org> <alpine.LFD.1.10.0807152341240.3283@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807151456490.2867@woody.linux-foundation.org>
 <20080715220547.GA11448@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008, Ingo Molnar wrote:
> >
> > ie it looks like even master has b9d2252c1 as tip (which is the one 
> > you say is the parent).
> > 
> > I wonder if Ingo overwrote it. You both push to the same tree, don't 
> > you? And maybe somebody used "-f" to force an over-push?
> 
> sorry, my fault - i have reset it back to -git because i wanted to get 
> rid of the local merge commit that we created over 
> include/asm-x86/dwarf2.h. That coincided with Thomas pushing an urgent 
> fix out. We rarely push out via -f but this was an exception.
> 
> Thomas, could you please push it again?

Done so.

Linus,

can you please pull again from

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/urgent

Thanks,

	tglx
