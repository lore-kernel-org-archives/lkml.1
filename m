Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbXFPHVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbXFPHVv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 03:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXFPHVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 03:21:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57443 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbXFPHVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 03:21:42 -0400
Date: Sat, 16 Jun 2007 09:21:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Michael Gerdau <mgd@technosis.de>,
       Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070616072125.GA31926@elte.hu>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <alpine.LFD.0.98.0706150913480.14121@woody.linux-foundation.org> <200706160006.26428.mgd@technosis.de> <200706151830.46175.dhazelton@enter.net> <20070615224403.GA23721@elte.hu> <alpine.LFD.0.98.0706151548070.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706151548070.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Furthermore when you get source code of free software then there is 
> > no "meeting of minds" needed for you to accept the GPL's conditions, 
> > and only the letter of the license (and, in case of any ambiguities, 
> > the intent of the author of the code) matters to the interpretation 
> > of the license, not the intent of the recipient. (while in contract 
> > cases both the meeting of minds is needed and the intent and 
> > understanding of both parties matters to the interpretation of the 
> > contract.)
> 
> I do agree that you can probably use this to say that the intent of 
> the copyright has a stronger position, and that his "intent" thus 
> matters more.
> 
> But I suspect that the "intent" angle is fairly weak legally to begin 
> with, and if you cannot show that the intent was mutual, it's probably 
> weaker still. So yeah, the intent of the copyright owner arguably 
> might matter more, but quite frankly, I suspect everbody is better off 
> not worrying so much about "intent", and worrying more about the 
> "terms and conditions" part.

yeah - and from everything i know about this subject the distinction 
between contract and license is small and more of a technicality - but 
still, it's a nice touch that the "pure license" argument that the FSF 
has advanced for a long time (and which it is now more silent about, 
given the GPLv3's not so pure structure) neatly defeats the common 
argument:

  "but, but, when i received the Tivo with GPL-ed software on it the 
   GPLv2 was not intended to be like that, there is a right to run 
   modified software on the hardware!"

> What is pretty clear, though, is that the intent of a third party in 
> the license/cotnract matters not at all. In the case of the kernel, 
> the FSF being such a third party.

yeah. But the argument goes a bit further: people who chose to _license_ 
the kernel (by receiving a Tivo for example and downloading its kernel 
source) claim that _their_ interpretation of the GPL is that of the 
FSF's and that Tivo ought to follow it. The whole "Tivo is cheating the 
GPL deal with the end users" line of PR. As far as license 
interpretation goes there is _no end user deal_ and the 'end user' does 
not even play in terms of intent - only if she choses to be an active 
member of the community. That's why i think it's better to talk about a 
license than a contract. (even though legally, at least in the US, the 
two are quite close to each other.)

so a 'pure copyright license' stresses the point even more that you only 
really count in the ecosystem if you contribute in one way or another. 
The system should be and _is_ assymetric towards the actual black letter 
text of the license and, as a second layer, towards the intent of the 
people who actually produced this 1+ billion lines of code, 
documentation, bugzilla entries and other nice works. And that is a 
thing the FSF is missing sometimes i believe - the "listen to _all_ the 
people who enabled this cool stuff" part.

	Ingo
