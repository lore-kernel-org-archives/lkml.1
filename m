Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbXFOThl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbXFOThl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbXFOThe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:37:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbXFOThd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:37:33 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Chris Friesen" <cfriesen@nortel.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, "debian developer" <debiandev@gmail.com>,
       david@lang.hm, "Tarkan Erimer" <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<20070615004513.6816e04b@the-village.bc.nu>
	<9a8748490706142359v3acbdf7m8731d6dc3071a775@mail.gmail.com>
	<200706150308.20148.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 16:37:04 -0300
In-Reply-To: <200706150308.20148.dhazelton@enter.net> (Daniel Hazelton's message of "Fri\, 15 Jun 2007 03\:08\:19 -0400")
Message-ID: <or1wgd102n.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> On Friday 15 June 2007 02:59:31 Jesper Juhl wrote:

>> it doesn't say anything about being able to run a compiled version
>> of that source on any specific hardware.

> And you are correct. It is also clear, thanks to language directly
> in the GPLv2 itself, that there is no "intent" of the license to
> cover that situation.

You're again confusing legal terms with the intent.  The legal terms
provide an indication of the intent, but the preamble, along with the
free software definition it alludes to, do an even better job at that.

That said, the letter of the GPL explicitly says that the act of
running the program is not restricted, and that this is outside the
scope of the license.  It's a copyright license, and per US law,
running software is not regulated by copyright; this is not so
elsewhere, and local interpretation indicates that the intent of the
license is indeed to grant unlimited permission to run the program and
modified versions thereof, based on the free software definition.


But then, when someone says "I won't let you run modified versions of
this software on this hardware I'm selling you", is this not a further
restriction on the exercise of the rights granted in the license?

And, per the spirit, if the manufacturer can still install and run
modified versions of the software on that hardware, is it not failing
to comply with the spirit of passing on all the rights that you have?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
