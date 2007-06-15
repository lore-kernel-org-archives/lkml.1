Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbXFOSzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbXFOSzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXFOSzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:55:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbXFOSzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:55:04 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Rob Landley <rob@landley.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
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
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 15:54:26 -0300
In-Reply-To: <20070615120926.GD6269@elte.hu> (Ingo Molnar's message of "Fri\, 15 Jun 2007 14\:09\:26 +0200")
Message-ID: <orvedp121p.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, Ingo Molnar <mingo@elte.hu> wrote:

> it irreversibly cuts off certain people from being to distribute
> GPLv3-ed software alongside with certain types of hardware that the
> FSF's president does not like.

That's not true.  They can just as well throw the key away and refrain
from modifying the installed software behind the users' back.

> The GPLv2 never did this kind of restriction _of other works_.

How about other works in which GPLed software is distributed?

I think your interpretation is mistaken or at least incomplete.

>   Activities other than copying, distribution and modification are not
>   covered by this License; they are outside its scope.

> guess why this section has been completely removed from the GPLv3, 
> without a replacement?

My guess:

First, because it was redundant, given that the license didn't quite
discuss other activities.  Unless you count say "imposing restrictions
on the exercise of others' freedoms" as other activities, even though
these are associated with modification and distribution.

Second, because GPLv3 does indeed talk about other activities, such as
starting lawsuits on patent and pro-DRM grounds, or entering
agreements for distribution of software along with limited patent
licenses.  All of these are still associated, at least to some extent,
with modification and distribution, but I guess it was worth
clarifying that claiming that such harmful activities are outside the
scope of the license isn't a valid excuse to escape the conditions
determined by the license.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
