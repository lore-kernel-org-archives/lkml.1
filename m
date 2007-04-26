Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbXDZL2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbXDZL2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 07:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbXDZL2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 07:28:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37823 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754665AbXDZL2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 07:28:06 -0400
Date: Thu, 26 Apr 2007 13:27:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070426112750.GT17387@elf.ucw.cz>
References: <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424205416.GA23032@elte.hu> <20070424212956.GE16457@elf.ucw.cz> <20070425214156.GI11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425214156.GI11166@waste.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > We do not want to fragment the testing base, and suspend2 does not
> > really have any interesting features over uswsusp.
> 
> The testing base is already fragmented!
> 
> What the current situation means is that you simply never hear from
> the people who get fed up with suspend but who manage to get suspend2
> working.

Well, and what can I do?

I can wait for suspend2 to slowly disappear on their own. Merging
suspend2 would just make testing base _more_ fragmented then it is today. 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
