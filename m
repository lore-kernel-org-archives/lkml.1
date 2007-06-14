Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbXFNUFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbXFNUFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbXFNUFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:05:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbXFNUFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:05:11 -0400
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
	<orodjie7gs.fsf@oliva.athome.lsd.ic.unicamp.br>
	<d120d5000706141200r744d7cdfv3bfbbf558a05248e@mail.gmail.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 17:01:52 -0300
In-Reply-To: <d120d5000706141200r744d7cdfv3bfbbf558a05248e@mail.gmail.com> (Dmitry Torokhov's message of "Thu\, 14 Jun 2007 15\:00\:15 -0400")
Message-ID: <ork5u6b8zz.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:

> Ok, consider non-derived work.

I did, you snipped it out:

>> If your change is not a derived work, you're not bound by the terms
>> of the GPL as far as the change is concerned, so the GPL has no say
>> whatsoever as to how you must release it.  If you choose the GPL,
>> then you're a licensor, and the requirements to pass on all the
>> rights you have do not apply.

> Because I am distributing whole program
> I have to do it under GPL. However I still have the right to
> distribute just the portion that is written by me under whatevel
> license I want but you as a recepient of GPLed whole do not get this
> right. IOW I am not passing all the rights _I have_.

I see what you mean.  IANAL, but I don't think that's how it works.

When your work is not a derived work, the GPL that applies to the rest
of the program does not make you a licensee, and it only covers your
work if you choose to license it that way.  And then, you're the sole
licensor of that piece of the work.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
