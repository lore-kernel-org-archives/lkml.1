Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbXHAODj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbXHAODj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932334AbXHAOD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:03:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60777 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbXHAOD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:03:28 -0400
Subject: Re: [ck] Re: Linus 2.6.23-rc1 -- It does not matter who's code
	gets merged!
From: Arjan van de Ven <arjan@infradead.org>
To: jos@mijnkamer.nl
Cc: Hua Zhong <hzhong@gmail.com>, Carlo Florendo <subscribermail@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Chang <thenewme91@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <5c77e14b0708010114x49e5c468gd71a77f2aa8cb48f@mail.gmail.com>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <200707282003.45142.jos@mijnkamer.nl>
	 <alpine.LFD.0.999.0707281109120.3442@woody.linux-foundation.org>
	 <200707282128.39906.jos@mijnkamer.nl>
	 <alpine.LFD.0.999.0707281313570.3442@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0708010539230.1818@scrub.home> <46B01E3F.6050401@gmail.com>
	 <005001c7d403$8d7601a0$a86204e0$@com>
	 <1185951901.2754.12.camel@laptopd505.fenrus.org>
	 <5c77e14b0708010114x49e5c468gd71a77f2aa8cb48f@mail.gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 01 Aug 2007 07:02:52 -0700
Message-Id: <1185976972.2754.21.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 10:14 +0200, jos@mijnkamer.nl wrote:
> On 8/1/07, Arjan van de Ven <arjan@infradead.org> wrote:
> > Let me repeat the key message:
> >
> > It does not matter who's code gets merged.
> > It does not matter who's code gets merged.
> > It does not matter who's code gets merged.
> > It does not matter who's code gets merged.
> >
> > What matters is that the problem gets solved and that the Linux kernel
> > innovates forward.
> 
> And, from a standpoint of ONGOING, long-term innovation: what matters
> is that brilliant, new ideas get rewarded one way or another.

and in this case, the reward is that the idea got used and credit was
given....

>  Because
> if you don't, the people with the 'different' ideas walk away, you end
> up with only those who 'fit' the culture, and there goes innovation.

yet at the same time if people walk away just because their code didn't
get used, even though their problem got solved, should we merge "worse"
code just to prevent that ? That's almost blackmail, and also just
stupid.

(not suggesting that SD in this case was better or worse, just trying to
make a general point)

> That's why I tried to get involved in this discussion. It doesn't
> matter who's code gets merged. But it does matter that people get
> scared away. It took the kernel folks a few years, but they managed to
> get someone kicked out who's not 'in-crowd', who clearly has a
> different view, and who has the intent and motivation to write and
> maintain code.

And he did manage to get some of his code in, just not all. He also
managed to get people interested in his problem so much that a healthy
stint of competition happened and his problem got solved. If people walk
away because they don't 100% always get things done EXACTLY their way..
well so be it.

> Of course that's 'overdone', but it conveys a point: If you focus too
> much on exploiting current code, instead of fundamentally exploring
> new ideas you go down in the long run. 

here's the thing. Fair scheduling DID get explored. deeply so.

now, getting people interested in your problem (and that is needed to
get them to pay attention to it) is a sales job, no ifs and buts there.
You need to convince them that 1) the problem is real, 2) the problem is
relevant. If you also have a proposed solution you also need to convince
them that 3) the solution solves the problem and 4) that it's the right
way to solve the problem. That isn't politics, it's part of how the
ecosystem works; people are not stupid, but you need to convince them
about your problem and solution. And that "default a bit skeptical and
overworked" approach is the foundation of the process; the same way as
you need to pass a code review before people will merge your code.
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

