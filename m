Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbXFQI31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbXFQI31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 04:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbXFQI3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 04:29:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055AbXFQI3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 04:29:17 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Scott Preece <sepreece@gmail.com>, Rob Landley <rob@landley.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
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
	<7b69d1470706151503v23253546w5648f04673741c8f@mail.gmail.com>
	<orodjgvm5v.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070617075748.GB6267@elte.hu>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sun, 17 Jun 2007 05:28:43 -0300
In-Reply-To: <20070617075748.GB6267@elte.hu> (Ingo Molnar's message of "Sun\, 17 Jun 2007 09\:57\:48 +0200")
Message-ID: <ortzt7htms.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 17, 2007, Ingo Molnar <mingo@elte.hu> wrote:

> * Alexandre Oliva <aoliva@redhat.com> wrote:

>> > if the manufacturer believes that it cannot legally allow software 
>> > modification, all the restriction does is force them either to make 
>> > the software unmodifiable (which advances freedom not at all) or to 
>> > use software under a different license (which advances freedom not 
>> > at all).
>> 
>> Right.
>> 
>> But if the manufacturer believes that it can legally allow it, and 
>> wants to be able to install, software modifications, then it must 
>> decide between giving that up and letting the user do it as well.  And 
>> this is where the users interests may prevail.

> with the little tiny problem that this is not what the GPLv3 actually 
> implements.

Except that it does.  Go read it, then come back and admit you were
mistaken and spreading lies about it.

The vendor must decide between respecting the freedom of the user, or
stopping itself from modifying the software too.

> But most fundamentally, a license should _never_ get into the 
> business of trying to 'judge' what _use_ is 'good' and what is 'evil'. 

What it does is to seek to carry out its mission (*) of defending
users' freedoms.  Obstacles that are placed to impede the user from
enjoying the freedoms are supposed to not be permitted by the GPL.

(*) it seems that understanding "spirit of a license" is very
difficult for you; does the term "mission" help you understand what
the GPL means when it says "similar in spirit"?

> But the GPLv3 completely destroys Tivo's ability to use Linux, were
> Linux to be under the GPLv3.

Sorry, wrong.  Barring nonsense.

> You tried to find a workaround for that, by suggesting the 'dont do 
> security fixes then', 'use a split key', 'use a rent model' solutions, 

FTR, rent model wasn't me, and it doesn't escape the GPLv3dd4
obligations IIUC, IANAL.

> but dont you realize that by suggesting those you are explicitly against 
> the intent of RMS, who wants to _stop_ Tivo from being able to do DRM? 

You misunderstand not only the spirit of the license, but his
intentions.  Oh, wait!  They're the same, that's why.

Respect and defend users' freedoms.

Repeat after me until it sinks.

I know you're not stupid.  Why do you pretend to be?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
