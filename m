Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbXFNSH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbXFNSH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbXFNSHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:07:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbXFNSHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:07:21 -0400
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Daniel Hazelton" <dhazelton@enter.net>,
       "Bongani Hlope" <bhlope@mweb.co.za>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Greg KH" <greg@kroah.com>, "debian developer" <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<200706132108.50030.dhazelton@enter.net>
	<orlkenjnxm.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706140125.24815.dtor@insightbb.com>
	<orps3zghgo.fsf@oliva.athome.lsd.ic.unicamp.br>
	<d120d5000706140856s5fdb29c6j1b53cafc291f8ec1@mail.gmail.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 15:06:43 -0300
In-Reply-To: <d120d5000706140856s5fdb29c6j1b53cafc291f8ec1@mail.gmail.com> (Dmitry Torokhov's message of "Thu\, 14 Jun 2007 11\:56\:10 -0400")
Message-ID: <orodjie7gs.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:

> On 6/14/07, Alexandre Oliva <aoliva@redhat.com> wrote:
>> On Jun 14, 2007, Dmitry Torokhov <dtor@insightbb.com> wrote:
>> 
>> > On Wednesday 13 June 2007 21:59, Alexandre Oliva wrote:
>> >> For example, if you distribute copies of such a program, whether
>> >> gratis or for a fee, you must give the recipients
>> >> all the rights that you have.
>> >> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> 
>> > So if I am a sole author of a program and I chose to distribute it under
>> > GPL
>> 
>> then you're not a licensee, you're a licensor, and these terms don't
>> apply to you.

> Heh. When you change a GPLed program and pass your changes you are the
> licensor for the new code. You still have a right and license pieces
> of the code you wrote under different license but you do not pass that
> right to recepient of modified work.

You are the author of the change, and you can license them however you
like.  Your change itself is not bound by the terms of the GPL, it is
only if it is a derived work of the GPLed work.

If your change is not a derived work, you're not bound by the terms of
the GPL as far as the change is concerned, so the GPL has no say
whatsoever as to how you must release it.  If you choose the GPL, then
you're a licensor, and the requirements to pass on all the rights you
have do not apply.

If it *is* a derived work, then you're constrained by the terms of the
license, and you can only distribute it under the same license.  You
don't have a right to offer it under a different license in the first
place, so you can't pass this right on.

Derived work or not, when you combine that change with the program,
then you're bound by the terms of the license, and then you cannot
change the licensing terms of the whole program, so you can't pass
this right on either.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
