Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbXFOXWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbXFOXWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbXFOXWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:22:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759522AbXFOXWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:22:31 -0400
To: "Scott Preece" <sepreece@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rob Landley" <rob@landley.net>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, "debian developer" <debiandev@gmail.com>,
       david@lang.hm, "Tarkan Erimer" <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<20070614122031.4751a52b@the-village.bc.nu>
	<20070614122546.GB22078@elte.hu> <200706141907.11957.rob@landley.net>
	<20070615120926.GD6269@elte.hu>
	<orvedp121p.fsf@oliva.athome.lsd.ic.unicamp.br>
	<7b69d1470706151503v23253546w5648f04673741c8f@mail.gmail.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 20:21:48 -0300
In-Reply-To: <7b69d1470706151503v23253546w5648f04673741c8f@mail.gmail.com> (Scott Preece's message of "Fri\, 15 Jun 2007 17\:03\:07 -0500")
Message-ID: <orodjgvm5v.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, "Scott Preece" <sepreece@gmail.com> wrote:

> On 6/15/07, Alexandre Oliva <aoliva@redhat.com> wrote:
>> On Jun 15, 2007, Ingo Molnar <mingo@elte.hu> wrote:
>> 
>> > it irreversibly cuts off certain people from being to distribute
>> > GPLv3-ed software alongside with certain types of hardware that the
>> > FSF's president does not like.
>> 
>> That's not true.  They can just as well throw the key away and refrain
>> from modifying the installed software behind the users' back.

> This characterization misses something important.  For many product
> devices, like cell phones, the modification is never "behind the
> user's back"

Okay, take out the "behind the users' back", it makes no difference.
That was just to highlight the frequent evil intentions behind keeping
the keys.

I wonder if giving half the key to the user and keeping the other half
would be enough to satisfy the GPLv3 language while still enabling the
vendor and user to update the software together.

> The FSF's approval of this distinction (ROM versus replaceable) places
> the FSF's particular principles over users interests, for no
> particular reason

Over *users* interest?  How so?

> if the manufacturer believes that it cannot legally allow software
> modification, all the restriction does is force them either to make
> the software unmodifiable (which advances freedom not at all) or to
> use software under a different license (which advances freedom not
> at all).

Right.


But if the manufacturer believes that it can legally allow it, and
wants to be able to install, software modifications, then it must
decide between giving that up and letting the user do it as well.  And
this is where the users interests may prevail.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
