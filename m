Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbXFPRPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbXFPRPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 13:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbXFPRPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 13:15:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbXFPRPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 13:15:03 -0400
To: Bron Gondwana <brong@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614195517.GA4933@elte.hu>
	<orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614235004.GA14952@elte.hu> <20070615041149.GA6741@brong.net>
	<orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615072322.GA7594@brong.net>
	<orabv110k5.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616021630.GA30660@brong.net>
	<orhcp8s402.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616103130.GD32405@brong.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sat, 16 Jun 2007 14:14:29 -0300
In-Reply-To: <20070616103130.GD32405@brong.net> (Bron Gondwana's message of "Sat\, 16 Jun 2007 20\:31\:30 +1000")
Message-ID: <orhcp7rfd6.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 16, 2007, Bron Gondwana <brong@fastmail.fm> wrote:

> On Sat, Jun 16, 2007 at 05:22:21AM -0300, Alexandre Oliva wrote:
>> On Jun 15, 2007, Bron Gondwana <brong@fastmail.fm> wrote:
>> 
>> > because it could easily be argued that they linked the BIOS with the
>> > Linux kernel
>> 
>> How so?

> Er, they installed it in the same piece of equipment, and the kernel
> couldn't function without it in that work.

I see what you're getting at.  You're thinking of a license that
doesn't respect the idea of "mere aggregation", right?

For starters, this wouldn't evidently not qualify as an Open Source
license, and I'm pretty sure it wouldn't qualify as a Free Software
license either.

> By using GPLix as part of their boot process along with their
> non-GPL BIOS, they're subverting the freedoms that the user should
> have in being able to control the entire boot process.

You're pushing the "freedom to change" too far.  Sure, I'd like to be
able to do that, and I prefer hardware that lets me do it, but it's
not like this BIOS in the scenario you described is being used as a
means to stop me from modifying the GPLed software.

I have never said that including a GPLed piece of software should
grant users the right to modify anything whatsoever in the system, or
grant them control over the entire system.  Others have, but it's not
true, it just shows how much mis-information is floating around.

All the GPL stands for is to defend the freedom of the users over the
particular program it applies to.  You can't impose further
restrictions on the user's ability to modify what *that* software
does.

If you wanted to change something else, but this something else is not
covered by the license, and is not being used to contradict the terms
of the license, well, too bad, you lose.

> b) deny themselves the ability to every offer a patch to said BIOS if
>    bugs are found 

> Point (b) is also exactly on topic for the discussion of enforcing
> legal safety obligations in hardware on a peripheral rather than the
> software drivers.

> It's requiring that these limitations be placed in a technically
> inferior location to hack around a legal "bug".

I don't think this last sentence is true.  If you implement hardware
locks that prevent modification of the software even by yourself, then
you're in compliance with the terms of the GPLv3dd4.  But IANAL.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
