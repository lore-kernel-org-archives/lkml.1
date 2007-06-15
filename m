Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbXFOQTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbXFOQTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755886AbXFOQSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:18:49 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:35441
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755684AbXFOQSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:18:48 -0400
To: Florin Malita <fmalita@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<200706142246.57583.dhazelton@enter.net>
	<878xal2a0q.fsf@graviton.dyn.troilus.org>
	<200706150127.18069.dhazelton@enter.net>
	<87sl8tzaj1.fsf@graviton.dyn.troilus.org>
	<20070615124039.GB21120@elte.hu>
	<87fy4tz8dc.fsf@graviton.dyn.troilus.org>
	<20070615143003.GA8775@elte.hu>
	<87zm31xo3q.fsf@graviton.dyn.troilus.org> <4672B5F6.706@gmail.com>
From: Michael Poole <mdpoole@troilus.org>
Date: Fri, 15 Jun 2007 12:18:47 -0400
In-Reply-To: <4672B5F6.706@gmail.com> (Florin Malita's message of "Fri\, 15 Jun 2007 11\:53\:26 -0400")
Message-ID: <87r6odxkbc.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florin Malita writes:

> On 06/15/2007 10:56 AM, Michael Poole wrote:
>> The GPL cares about the key
>> used to generate an integral part of the executable form of the GPLed
>> work.  
>
> GLPv2 doesn't: why do you think the digital signature is an integral
> part of the executable? It can be a totally separate blob, distributed
> via a separate channel and even stored at a different location than
> the executable. Does it still look like an integral part of the
> executable to you then?

Yes.  If I cut a book in half and store the halves separately, does
the second half become an independent work?  The integral-ness is a
function of how the thing is created and how it functions, not how it
is stored.  If you need part B for part A to execute as intended, then
part A is not a complete work in itself.  On top of this, in the Tivo
case the two are distributed together, and even part of the same file.

[snip]
> Do you honestly believe GPLv2 requires the distributor to provide you
> with the right environment for your modified copy to "function
> properly"? I would say it doesn't, but feel free to point me to
> specific sections which *state* otherwise. AFAICT, GPLv2 is
> specifically limited to "copying, distribution and modification". How
> you use (or don't use, or can't use) your modified copy is totally
> outside its scope.

The GPL does not require a distributor to provide me with any kind of
environment.  If I get a Tivo kernel image but do not have a Tivo, the
GPL does not require anyone to give me hardware.  Fortunately, that is
not at all my argument.

Michael Poole
