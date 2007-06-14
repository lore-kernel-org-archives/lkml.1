Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbXFNVlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbXFNVlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXFNVk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:40:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbXFNVk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:40:56 -0400
To: Florin Malita <fmalita@gmail.com>
Cc: Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org>
	<ortztbgi03.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706140305.50095.dhazelton@enter.net>
	<orr6oefpg4.fsf@oliva.athome.lsd.ic.unicamp.br>
	<46717C58.8050501@gmail.com>
	<ord4zye6iv.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4671A528.5040300@gmail.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 18:39:32 -0300
In-Reply-To: <4671A528.5040300@gmail.com> (Florin Malita's message of "Thu\, 14 Jun 2007 16\:29\:28 -0400")
Message-ID: <or1wge9pwr.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Florin Malita <fmalita@gmail.com> wrote:

> On 06/14/2007 02:27 PM, Alexandre Oliva wrote:
>>> No, by this twisted logic Tivo *cannot* modify that particular copy
>>> any more than you can. They can modify *another* copy (just like you)
>>> and they can *replace* the copy in your device with the new version
>>> (unlike you).

>> Again, replacing is one form of modification.

> No, it's not: replacing does not create derivative
> work. Modification does.

Thanks.  Good point.  This convinces me that this doesn't work as a
legal argument under copyright.

I still stand by my understanding that this restriction violates the
spirit of the license.

And since the specific implementation involves creating a derived work
of the GPLed kernel (the signature, or the signed image, or what have
you) and refraining from providing the corresponding sources to that
derived work (the key and the signature "build scripts"), I still
think this specific case is a violation of the letter of the GPLv2,
even if the FSF doesn't take this position.

> It seems pretty obvious that the only right Tivo is withholding is the
> right to install new versions on the device

Actually, no.  They withhold the right to run versions that they don't
authorize themselves.

Back when GPLv2 was written, the right to run was never considered an
issue.  It was taken for granted, because copyright didn't control
that in the US (it does in Brazil), and nobody had thought of
technical measures to stop people from running modified copies of
software.  At least nobody involved in GPLv2, AFAIK.

The landscape has changed, and GPLv3 is meant to defend this freedom
that was taken for granted.

> they never do (and really never could) "modify" the physical copy on
> your device (which is your main argument).

Qualifying it as the main argument is a bit of an exaggeration.  I
have a number of different arguments.  The one about incomplete
sources is the most solid IMHO.

>> What do you think you do when you save a modified source file in your
>> editor?

> Don't skip the part where the in-memory version started as an exact
> copy of the original being replaced. Notice the difference? ;)

Sorry, I really don't follow.  Both versions of the kernel binary also
started from a common source ancestor.  Were you trying to make a
distinction on these grounds?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
