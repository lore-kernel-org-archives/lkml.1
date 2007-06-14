Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbXFNSDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbXFNSDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbXFNSDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:03:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbXFNSD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:03:29 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<alpine.LFD.0.98.0706131456230.14121@woody.linux-foundation.org>
	<orejkfla3l.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706131946.15714.dhazelton@enter.net>
	<20070614004419.GL3588@stusta.de>
	<alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org>
	<ortztbgi03.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706140817520.14121@woody.linux-foundation.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 15:01:53 -0300
In-Reply-To: <alpine.LFD.0.98.0706140817520.14121@woody.linux-foundation.org> (Linus Torvalds's message of "Thu\, 14 Jun 2007 08\:34\:22 -0700 \(PDT\)")
Message-ID: <orsl8ue7ou.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 14 Jun 2007, Alexandre Oliva wrote:
>> 
>> People don't get your copy, so they're not entitled to anything about
>> it.
>> 
>> When they download the software, they get another copy, and they have
>> a right to modify that copy.

> Umm. I notice how you must have known how *idiotic* your response was, 
> because you snipped away the part where I talked about Red Haty 
> distributing CD-ROM's.

> In other words, Red Hat distributes copies (and yes, you *get* that copy), 
> and you cannot modify that copy that you got.

And Red Hat can't either.  I thought that was quite obvious.

>> > See any parallels here? Any parallel to a CD-ROM distribution, or a Tivo 
>> > distribution?

>> Yes.  You see how TiVO is different?  It is modifyable, and I actually
>> receive the copy that TiVO can still modify, but I can't.

> You keep on harping on that "modifyable", but no-where in the GPLv2 is 
> that an issue. I claim that it *cannot* be an issue, since CD's are 
> obviously ok.

The 'passing on the rights you have' makes it an issue.

> You cannot use that as an argument that the GPLv3 didn't change things, 

Compare the preambles of v2 and v3 and you'll understand why the
argument is sound, and not circular.

> Those people who have argued for using the BSD license, btw, argued so in 
> the name of "freedom".

But individual freedom, rather than community freedom.

Think local vs global optimization.

> If so, why the hell do you think _you_ are right?

Because, like you, I'm always right, even though not everyone agrees
with that assessment? ;-P :-D

>  - do you admit that the GPLv3 is a new license that does new and 
>    different things?

Yes, of course.  The new legal terms are answers to new threats to the
freedoms depicted in the preamble, that didn't exist or hadn't been
thought of by the time GPLv2 was published.

>  - do you admit that I chose the GPLv2, and have argued that I chose it 
>    because I understood what it said?

Yes.

>  - do you admit that authors have the right to choose their own licenses?

Within the boundaries of ethics and morals, yes.

>  - if you answered "yes" to all the above questions, HOW THE HELL can you 
>    call me confused, and argue against me when I say that the GPLv2 is a 
>    better license? It wasn't your choice. 

The thing is I'm not arguing that point.

I'm disputing that there was a change in the spirit of the license
between v2 and v3.  Heck, a mere 48 hours ago you couldn't even tell
the spirit from the legal terms.


I still think v3 will serve better any Free Software community,
because it will push away the abusers that contribute little, or turn
them into cooperative or at least harmless participants, that further
enable the active participation of their downstream users.  This would
enable wider participation under the same 'tit-for-tat' conditions
that you attribute to GPLv2.


It appears to me that the only significant point of contention
remaining is the issue of Tivoization.  If you feel so strongly about
permitting Tivoization, even though it denies the freedoms that the
original spirit of the license you chose says they are entitled to
have, you can make this provision by means of an additional permission
for that, on top of GPLv3, and be done with it.

> It really is that easy. 

Yes, indeed.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
