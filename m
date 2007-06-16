Return-Path: <linux-kernel-owner+w=401wt.eu-S1759394AbXFPAYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbXFPAYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 20:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbXFPAX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 20:23:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325AbXFPAX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 20:23:58 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Rob Landley <rob@landley.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<20070614122031.4751a52b@the-village.bc.nu>
	<20070614122546.GB22078@elte.hu> <200706141907.11957.rob@landley.net>
	<20070615120926.GD6269@elte.hu>
	<orvedp121p.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615214804.GC4996@elte.hu>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 21:22:50 -0300
In-Reply-To: <20070615214804.GC4996@elte.hu> (Ingo Molnar's message of "Fri\, 15 Jun 2007 23\:48\:04 +0200")
Message-ID: <or3b0svjc5.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, Ingo Molnar <mingo@elte.hu> wrote:

> * Alexandre Oliva <aoliva@redhat.com> wrote:

>> On Jun 15, 2007, Ingo Molnar <mingo@elte.hu> wrote:
>> 
>> > it irreversibly cuts off certain people from being to distribute
>> > GPLv3-ed software alongside with certain types of hardware that the
>> > FSF's president does not like.

>> That's not true.  They can just as well throw the key away and refrain 
>> from modifying the installed software behind the users' back.

> uhm, so you claim that my argument is false, and your proof for that is 
> a "non-upgradeable Tivo"?? <sarcasm> That is a _great_ idea. Not being 
> able to patch security holes. Not being able to fix bugs. Not being able 
> to add new features. Makes complete sense.

Oh, so you think patching security holes, fixing bugs and adding new
features are good ideas?  What if you can't do it in your TiVo?

>> > guess why this section has been completely removed from the GPLv3, 
>> > without a replacement?

>> My guess:

>> First, because it was redundant, given that the license didn't quite 
>> discuss other activities.  Unless you count say "imposing restrictions 
>> on the exercise of others' freedoms" as other activities, even though 
>> these are associated with modification and distribution.

> here you prove that you cannot even read what i wrote. I wrote that this 
> section has been removed from the GPLv3. What relevance does it have 
> that in your opinion this section was redundant in the GPLv2??

If you didn't mean "removed from the GPLv3 as compared with v2", I
misunderstood what you wrote.

The fact that it's redundant is v2 means it is reasonable to take it
out.  That's the relevance.

> It would clearly not be redundant in the GPLv3: it would contradict
> and _completely neutralize_ most of the crap from the GPLv3 that we
> are talking about here ...
 
And, per the same reasoning, some of the v2 provisions as well.

> dont you realize that declaring certain types of activities by hardware 
> makers as being "against freedom" is _exactly_ such an activity that the 
> GPLv2 did not attempt to control?

No.  And some Linux hackers disagree with your assessment too.

> censure, opression of free speech, out of control climate,
> dictatorship, campaign financing laws, the WIN32 API and human
> stupidity. By your argument we'd have to add prohibition against
> those restrictions of freedom to the license too, right?

-ENONSEQUITUR

How do these stop a user's exercise of the four freedoms of a piece of
software licensed under the GPL?

> Your argument still leads to absurd results, even now that you've
> modified it a few times already ...

I hope you're not saying that my listening to you, recognizing
mistakes in my arguments and fixing them up is a bad thing.

But hey, at least I'm not modifying my arguments as much as you are!
;-)

It's pretty easy to shoot a straw man and claim the original argument
was broken.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
