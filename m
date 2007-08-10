Return-Path: <linux-kernel-owner+w=401wt.eu-S941133AbXHJTo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941133AbXHJTo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762545AbXHJToR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:44:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43525 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762284AbXHJToQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:44:16 -0400
Date: Fri, 10 Aug 2007 21:44:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Michael Chang <thenewme91@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070810194404.GA27474@elte.hu>
References: <p73ps27npu0.fsf@bingen.suse.de> <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org> <20070801175004.GA17936@elte.hu> <Pine.LNX.4.64.0708011955430.1817@scrub.home> <20070801190556.GA1199@elte.hu> <Pine.LNX.4.64.0708100037460.1817@scrub.home> <20070810054948.GA5908@elte.hu> <Pine.LNX.4.64.0708101459530.1817@scrub.home> <b14e81f00708100954w71e953fcm8a5cca464e4b27df@mail.gmail.com> <Pine.LNX.4.64.0708101919270.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708101919270.1817@scrub.home>
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

> > Not yet, but if you give Ingo what he wants (as opposed to what 
> > you're giving him) it'll be easier for him to answer what's going 
> > wrong, and perhaps "fix" the problem to boot.
> > 
> > (The scripts gives info about CPU characteristics, interrupts, 
> > modules, etc. -- you know, all those "unknown" variables.)
> 
> He already has most of this information and the trace shows _exactly_ 
> what's going on. [...]

i'll need the other bits of information too to have a complete picture 
about what's going on while your test is running - to maximize the 
chances of me being able to fix it. I'm a bit perplexed (and a bit 
worried) about this - you've spent _far_ more effort to _not send_ that 
script output (captured while the workload is running) than it would 
have taken to do it :-/ If you'd like me to fix bugs then please just 
send it (in private mail if you want) - or give me an ssh login to that 
box - whichever variant you prefer. Thanks,

	Ingo
