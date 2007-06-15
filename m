Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbXFOSbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbXFOSbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbXFOSaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:30:55 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:53956
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbXFOSay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:30:54 -0400
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
	<87r6odxkbc.fsf@graviton.dyn.troilus.org> <4672C6BA.6020702@gmail.com>
From: Michael Poole <mdpoole@troilus.org>
Date: Fri, 15 Jun 2007 14:30:53 -0400
In-Reply-To: <4672C6BA.6020702@gmail.com> (Florin Malita's message of "Fri\, 15 Jun 2007 13\:04\:58 -0400")
Message-ID: <87k5u5xe76.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florin Malita writes:

> On 06/15/2007 12:18 PM, Michael Poole wrote:
>> Florin Malita writes:
>>
>>   
>>> On 06/15/2007 10:56 AM, Michael Poole wrote:
>>>     
>>>> The GPL cares about the key
>>>> used to generate an integral part of the executable form of the GPLed
>>>> work.        
>>> GLPv2 doesn't: why do you think the digital signature is an integral
>>> part of the executable? It can be a totally separate blob, distributed
>>> via a separate channel and even stored at a different location than
>>> the executable. Does it still look like an integral part of the
>>> executable to you then?
>>>     
>>
>> Yes.  If I cut a book in half and store the halves separately, does
>> the second half become an independent work?  
>
> Except in this case you're not touching the book at all. If you write
> a review for a book (much better analogy methinks), then your review
> is obviously not an integral part of the book even though it's based
> on its content.

Extremely poor analogy.  I do not distribute my review with the book.
Someone buying the book is able to use the book just fine (for the
purpose for which it was sold) without my review.  They need neither
my review nor other modifications before the book becomes readable.
As Ingo said, you need either the digital signature or other changes
before a Tivo kernel image will load.

>> The integral-ness is a
>> function of how the thing is created and how it functions, not how it
>> is stored.  If you need part B for part A to execute as intended, then
>> part A is not a complete work in itself.
>
> Being an integral part (as in combined or derived work) has nothing to
> do with usability. There are many other bits and pieces your
> executable needs in order to function properly (or at all) but that
> doesn't make your CPU microcode & electricity provider an integral
> part of the program, does it?

No.  Those are independent works.  They are not distributed to make a
certain piece of software function in a particular way or place.  The
presence of software in a box with CPU microcode is -- at least in
every case I have seen -- what GPL calls "mere aggregation".

> Luckily, it doesn't really matter what you or I think that
> "integral-ness" means, all it matters is how copyright law defines a
> "derivative work" and whether a cryptographic hash is such a
> thing. Now are you seriously arguing that a hash is a derivative work?

No.  I explained this before.  Try reading the thread and the GPL.  I
am not sure where people get the (wrong) idea that the GPL only
concerns itself with "derivative work[s]".

>>   On top of this, in the Tivo
>> case the two are distributed together, and even part of the same file.
>>   
>
> It's mere aggregation, but it's totally irrelevant because they could
> just as easily change their approach.

If and when they do, I'll consider the rules that might apply.  Until
then, it is fairly stupid to try to defend Tivo by saying they *might*
do something they currently don't, and if they did, they *might* have
a defense that they currently don't.

Michael Poole
