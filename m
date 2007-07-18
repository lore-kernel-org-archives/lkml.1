Return-Path: <linux-kernel-owner+w=401wt.eu-S933947AbXGRQTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947AbXGRQTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbXGRQT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:19:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51559 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760971AbXGRQTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:19:25 -0400
Date: Wed, 18 Jul 2007 18:17:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Matt Mackall <mpm@selenic.com>, James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
Message-ID: <20070718161751.GA510@elte.hu>
References: <20070716203117.GC11166@waste.org> <20070716211851.GB18661@elte.hu> <Pine.LNX.4.64.0707162351030.1817@scrub.home> <20070716222909.GA30906@elte.hu> <Pine.LNX.4.64.0707170047230.1817@scrub.home> <Pine.LNX.4.64.0707170437110.1818@scrub.home> <20070717080230.GC13539@elte.hu> <Pine.LNX.4.64.0707171324110.1817@scrub.home> <20070718104001.GA2801@elte.hu> <Pine.LNX.4.64.0707181330480.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707181330480.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> Don't make such suggestions if you have no idea how insulting they 
> are. Especially the one deleted insult above where you have the 
> impertinence to quote it, such tone is more appropriate between lord 
> and inferior, where the latter have to make a request and the former 
> "might" grant it. [...]

uhm, [and the uninterested reader might want to skip to the next mail 
;-)], i'm really confused about your reply. Do you really mean this:

> > Roman, please do me a favor, and ask me the following question:
> >
> >  " Ingo, you've been maintaining the scheduler for years. In fact you
> >    wrote the old nice code we are talking about here. You changed it a
> >    number of times since then. So you really know what's going on here.
> >    Why does the old nice code behave like that for nice +19 levels? "
> >
> > I've been waiting for that obvious question, and i _might_ be able
> > to answer it, but somehow it never occured to you ;-) Thanks,

the ";-)" emoticon (and its contents) clearly signals this as a 
sarcastic, tongue-in-cheek remark. To make it even clearer, please 
re-read it with the <sarcastic> tag added as well for clarity:

> > <sarcastic>
> >
> > Roman, please do me a favor, and ask me the following question:
> >
> >  " Ingo, you've been maintaining the scheduler for years. In fact you
> >    wrote the old nice code we are talking about here. You changed it a
> >    number of times since then. So you really know what's going on here.
> >    Why does the old nice code behave like that for nice +19 levels? "
> >
> > I've been waiting for that obvious question, and i _might_ be able
> > to answer it, but somehow it never occured to you ;-) Thanks,
> >
> > </sarcastic>

ok? (If you didnt see/read it as sarcastic straight away then my 
apologies for insulting you!)

The "_might_ be able to answer" bit is of course sarcastic too, and 
contrary to your (i have to say, pretty absurd) suggestion i did not 
suggest that i "might be _willing_ to answer" - which would be quite 
arrogant indeed and which i never said or suggested. To make it even 
clearer: i'm definitely able to answer questions about code i wrote 
originally and which i just changed, were you to show genuine interest 
in hearing my opinion :-)

	Ingo
