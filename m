Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbXFOUFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbXFOUFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbXFOUFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:05:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705AbXFOUFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:05:43 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706142237.31289.dhazelton@enter.net>
	<ory7il51ix.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706150114.28068.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 17:04:15 -0300
In-Reply-To: <200706150114.28068.dhazelton@enter.net> (Daniel Hazelton's message of "Fri\, 15 Jun 2007 01\:14\:27 -0400")
Message-ID: <orfy4tyog0.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> On Thursday 14 June 2007 23:39:50 Alexandre Oliva wrote:
>> On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
>> > You're making an artificial distinction based on whether the
>> > *SOFTWARE* has a certain license or not.
>> 
>> What matters to me is that, when the GPL says you can't impose further
>> restrictions, then you can't, no matter how convoluted your argument
>> is

> Convoluted? Not in the least.

I didn't say your arguments were convoluted, and I know I didn't mean
to say that.  But I've heard enough arguments about excuses to escape
the obligations of the GPL (and other licenses and obligations, FWIW)
to know that such arguments can get very convoluted.

That said, I was actually trying to quote Eben Moglen, who once spoke
about this, but the word he used was "elaborate", not "convoluted".
Unfortunately, the right word escaped me ATM.

>> > If the intent of a law (or license) is to do A but it doesn't say
>> > that, then how is the intent to be known?  Your answer: Ask the
>> > author.
>> 
>> No, you interpret based on what the author wrote then.

> Really? Well I must say I'm surprised at the sudden change of heart. I have 
> several mails here in which you have either said "You ask the author" or that 
> line has been quoted.

It's no change.  You interpret what's there.  If it's clear, good.  If
there's a dispute, you have to ask the author, only s/he knows what
s/he meant.  It's really that simple.

> Show me where in the preamble that this issue of "it must run on any given 
> piece of hardware"

Why is the burden of the proof on me?

You show me where it says "one may impose restrictions on what
particupar pieces of hardware the program can run", to override the
general spirit of "passing on all the rights one has".

> (And, by the way, if the FSF decided to release a GPLv4 that had an active 
> section that said "You must turn over all copyright rights to a work released 
> under this license to the FSF" it wouldn't "break spirit" with the GPL (v2 or 
> v3).

Can't.  These terms wouldn't apply to the copyright holder (the only
person who could make the transfer), only to licensees.

> If "tivoization" was against the spirit, then all that would have been needed 
> was one extra clause clearly explaining that. Instead there are more than 6 
> extra sections in the GPLv3.

Erhm...  How did you get the (completely flawed, BTW) impression that
tivoization was all GPLv3 was about?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
