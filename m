Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbXFOTkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbXFOTkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbXFOTk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:40:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbXFOTkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:40:25 -0400
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Cc: "Daniel Hazelton" <dhazelton@enter.net>,
       "Chris Friesen" <cfriesen@nortel.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Greg KH" <greg@kroah.com>, "debian developer" <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<4671B734.1040401@nortel.com>
	<orhcpa88b0.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706142155.34298.dhazelton@enter.net>
	<or4pl96gvr.fsf@oliva.athome.lsd.ic.unicamp.br>
	<9a8748490706150007v71292f5drf6f4e78200eac703@mail.gmail.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 16:39:50 -0300
In-Reply-To: <9a8748490706150007v71292f5drf6f4e78200eac703@mail.gmail.com> (Jesper Juhl's message of "Fri\, 15 Jun 2007 09\:07\:28 +0200")
Message-ID: <orwsy5ypkp.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, "Jesper Juhl" <jesper.juhl@gmail.com> wrote:

> On 15/06/07, Alexandre Oliva <aoliva@redhat.com> wrote:
>> On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
>> 
>> > Faulty logic. The hardware doesn't *restrict* you from *MODIFYING*
>> > any fscking thing.

>> case 2'': tivo provides source, end user tries to improve it, realizes
>> the hardware won't let him use the result of his efforts, and gives up

> So?  The user still has the source and is free to use that in other
> GPLv2 projects, that's the point.

This point of yours is a distraction from the argument in this
sub-thread.


These cases were Chris Friesen's attempt to show that GPLv2 was
tit-for-tat, and case 2'' shows it isn't, at least not in the sense he
tried to picture it:


On Jun 14, 2007, "Chris Friesen" <cfriesen@nortel.com> wrote:

> Alexandre Oliva wrote:

>> That's where Linus' theory of tit-for-tat falls apart.

> Nope.

> case 1:  Upstream provides source, tivo modifies and distributes it
> (to their customers).

> case 2: tivo provides source, end user modifies and distributes it
> (possibly to their customers, maybe to friends, possibly even to
> upstream).

> See?  Tit for tat.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
