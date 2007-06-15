Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbXFOTEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbXFOTEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbXFOTEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:04:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbXFOTEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:04:31 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <200706132121.04532.dhazelton@enter.net>
	<orhcpbjnqj.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706132304.21984.dhazelton@enter.net>
	<20070614112329.3645c397@the-village.bc.nu>
	<20070614103846.GA7902@elte.hu>
	<or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614195517.GA4933@elte.hu>
	<orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614235004.GA14952@elte.hu>
	<or645q6jp4.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615113123.GA6269@elte.hu>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 16:03:58 -0300
In-Reply-To: <20070615113123.GA6269@elte.hu> (Ingo Molnar's message of "Fri\, 15 Jun 2007 13\:31\:23 +0200")
Message-ID: <orr6od11lt.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, Ingo Molnar <mingo@elte.hu> wrote:

> * Alexandre Oliva <aoliva@redhat.com> wrote:

>> > by your argument, the user has some "right to modify the software", 
>> > on that piece of hardware it bought which had free software on it, 
>> > correct?

>> Yes.  This means the hardware distributor who put the software in 
>> there must not place roadblocks that impede the user to get where she 
>> wants with the software, not that the vendor must offer the user a 
>> sport car to take her there.

> see the slippery slope in action? Lets just use this limited concession 
> on your part and show that _even this_ leads to absurd results:

> - a "roadblock" such as a too small button?

Why is it too small?

> - a "roadblock" such as a soldered-on ROM instead of flash-ROM?

Why is it soldered-ROM on rather than flash-ROM?

> - a "roadblock" such as not opening up specifications to the hardware?

Why is it not open, and why does that get in the way of replacing the
software?

> - a "roadblock" such as not releasing the source of the BIOS?

Why is it not released, and why does that get in the way of replacing
the software?

> - a "roadblock" such as a virtual ROM implemented via an SHA1 key 
>   embedded in the hardware?

Why is the virtual ROM and the SHA1 key in the hardware?


Remember, the issue is intent.  If you do that for legitimate reasons,
such as technical limitations, industrial economic motives, etc,
you're probably fine.  But if you do that for the purpose of
restraining users' freedoms, then you're going against the intent (and
quite likely the letter) of the license.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
