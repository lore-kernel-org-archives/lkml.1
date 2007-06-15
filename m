Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbXFOTa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbXFOTa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbXFOTaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:30:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbXFOTaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:30:14 -0400
To: Rob Landley <rob@landley.net>
Cc: Florin Malita <fmalita@gmail.com>, Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<20070614234507.GA3860@nostromo.devel.redhat.com>
	<or1wge6jii.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706150316.56556.rob@landley.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 16:28:29 -0300
In-Reply-To: <200706150316.56556.rob@landley.net> (Rob Landley's message of "Fri\, 15 Jun 2007 03\:16\:52 -0400")
Message-ID: <or645p10gy.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, Rob Landley <rob@landley.net> wrote:

> On Thursday 14 June 2007 22:25:57 Alexandre Oliva wrote:
>> On Jun 14, 2007, Bill Nottingham <notting@redhat.com> wrote:
>> > Alexandre Oliva (aoliva@redhat.com) said:
>> >> And since the specific implementation involves creating a derived work
>> >> of the GPLed kernel (the signature, or the signed image, or what have
>> >> you)
>> >
>> > Wait, a signed filesystem image that happens to contain GPL code
>> > is now a derived work? Under what sort of interpretation does *that*
>> > occur?
>> 
>> Is the signature not derived from the bits in the GPLed component, as
>> much as it is derived from the key?

> Actually, you can't copyright, trademark, or patent a number.

Agreed.  And this counter-argument of yours is a distraction.

I was careful to not talk about "derived work".  Please read it again
under this clarification (that I'm pretty sure I'd already made
before, but it's getting hard to keep track of everything in this
thread ;-)

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
