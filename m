Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbXFNVUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbXFNVUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbXFNVUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:20:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbXFNVUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:20:32 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<200706140429.11049.dhazelton@enter.net>
	<orejkefnw9.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706141640.17217.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 18:19:51 -0300
In-Reply-To: <200706141640.17217.dhazelton@enter.net> (Daniel Hazelton's message of "Thu\, 14 Jun 2007 16\:40\:16 -0400")
Message-ID: <orabv29qtk.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> With GPLv2 and prior there was a simple guarantee that every
> "Licensee" had exactly the same rights. With GPLv3 you are forcing
> your ethics and morals on people - and isn't this exactly what the
> Roman Catholic church did during the Spanish Inquisition?

I fail to see the distinction you're making between GPLv2 and GPLv3.
AFAICT, with GPLv3, there still is a simple guarantee that every
licensee has exactly the same rights.

Sure, GPLv3 follows the spirit of the GPLs more strictly than GPLv2
possibly could.  How is that "forcing ethics and morals" any more than
GPLv2 was?

> Ah, but I never said I had a GPLv1 program.

I thought you had a copy of Linux and, per what you'd said before,
there was GPLv1 code in it.  I was just trying to make it easy for
you.

> If GPLv1 is still valid and available I should be able to find a
> copy of it *RIGHT* *NOW* to license a new project if I want to use
> GPLv1 as its license.

http://www.gnu.org/copyleft/copying-1.0.html

>> > And because its a device that connects to their network - and TiVO
>> > isn't a telecommunications company - they have the right to upgrade
>> > and configure the software inside however they want. (In the US at
>> > least)
>> 
>> But do they have the right to not pass this right on, under the GPL?

> Yes, they do. It isn't a right they have as "copyright holders" - in fact, it 
> isn't a part of their rights under the copyright at all. It's a part of their 
> rights as the owners of the network. 

How about the "no further restrictions" bit?

> Never claimed it was less obscure, just that you've usually got a board-room 
> filled with middle-aged men that might have problems agreeing that it is a 
> clear-cut case.

> Yes, but the fact that it would cost money to get the suit dropped is a 
> problem. 

Again, how are these arguments against GPLv3?  They apply equally to
any other license, including GPLv2.

>> Interpretation as applied to the legal terms, yes.  As for the spirit
>> of the license, the authors ought to know better than anyone else what
>> they meant.  Sure, other interpretations might lead to different
>> understandings as to what the readers *think* it means, but that
>> doesn't change what it was *intended* to mean.

> Doesn't matter what the author intended it to mean - at all. What matters is 
> how its interpreted when/if it shows up in court.

You're talking about the legal terms.  The spirit of the license is a
very different matter.  It can guide the interpretation of the legal
terms, but the author is at a better position than anyone else to know
what he meant.

>> If you replace a component in the hardware, are you still required to
>> provide support or offer warranty?  Why should this be different just
>> because it's a software component?

> Artificial distinctions in the law

Well, then, lock down the software.  Make it irreplaceable, even by
yourself.  Problem solved.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
