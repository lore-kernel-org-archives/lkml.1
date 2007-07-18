Return-Path: <linux-kernel-owner+w=401wt.eu-S1763784AbXGRMoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763784AbXGRMoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 08:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbXGRMoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 08:44:11 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4248 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759291AbXGRMoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 08:44:10 -0400
Date: Wed, 18 Jul 2007 14:40:07 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Matt Mackall <mpm@selenic.com>, James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
In-Reply-To: <20070718104001.GA2801@elte.hu>
Message-ID: <Pine.LNX.4.64.0707181330480.1817@scrub.home>
References: <20070716134036.GA1533@elte.hu> <Pine.LNX.4.64.0707161548000.1817@scrub.home>
 <20070716203117.GC11166@waste.org> <20070716211851.GB18661@elte.hu>
 <Pine.LNX.4.64.0707162351030.1817@scrub.home> <20070716222909.GA30906@elte.hu>
 <Pine.LNX.4.64.0707170047230.1817@scrub.home> <Pine.LNX.4.64.0707170437110.1818@scrub.home>
 <20070717080230.GC13539@elte.hu> <Pine.LNX.4.64.0707171324110.1817@scrub.home>
 <20070718104001.GA2801@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 18 Jul 2007, Ingo Molnar wrote:

> > > Roman, please do me a favor, and ask me the following question:
> > > 
> > >  [insult deleted]


> In this discussion about 
> nice levels you were (very) agressively asserting things that were 
> untrue,

Instead of simply asserting things, how about you provide some examples?
I made so far a single mistake of mixing up nice levels 18 and 19.
If you would point me to such examples, I could learn how to tone it down 
a little, since the nice levels are not the only issue I have with the new 
scheduler, the heavy stuff is still about to come. The problem here is 
there is too much burnt ground so I can't just present raw ideas, which 
get flamed by you, I have to be sufficiently confident they are valid, 
what you might then interpret as "agressive assertion".

> you were suggesting that i dont understand the code,

Again, please point me to examples, so I at least have a chance to clear 
things up, since it was never my intention to make such a suggestion, but 
this gives me no chance to defend myself.

OTOH I can tell you exactly how you continuously insult me, e.g. by 
suggesting I ask "stupid questions" or that I'm in "denial of facts".
Don't make such suggestions if you have no idea how insulting they are. 
Especially the one deleted insult above where you have the impertinence to 
quote it, such tone is more appropriate between lord and inferior, where 
the latter have to make a request and the former "might" grant it. 
_Never_ make me beg. :-(

bye, Roman
