Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbXFOVRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbXFOVRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbXFOVRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:17:39 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:43140 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762AbXFOVRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:17:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ogtefeqp+neRnwdeavVoAC6R7oUffAXmk2nmXTQuhkvubu5ut55qZFFV4dddYqoj62LOVRUMlaoy/OBf/clBj1825P7mEnZbx8BoJxJBsDuT8tThUN5qgvByY7vzy4DUP9WWsEbIa0ew2dRriPrOTvq/M6qio5jcywD+74DECI0=
Message-ID: <467301E0.7070504@gmail.com>
Date: Fri, 15 Jun 2007 17:17:20 -0400
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Michael Poole <mdpoole@troilus.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>	<200706142246.57583.dhazelton@enter.net>	<878xal2a0q.fsf@graviton.dyn.troilus.org>	<200706150127.18069.dhazelton@enter.net>	<87sl8tzaj1.fsf@graviton.dyn.troilus.org>	<20070615124039.GB21120@elte.hu>	<87fy4tz8dc.fsf@graviton.dyn.troilus.org>	<20070615143003.GA8775@elte.hu>	<87zm31xo3q.fsf@graviton.dyn.troilus.org> <4672B5F6.706@gmail.com>	<87r6odxkbc.fsf@graviton.dyn.troilus.org> <4672C6BA.6020702@gmail.com> <87k5u5xe76.fsf@graviton.dyn.troilus.org>
In-Reply-To: <87k5u5xe76.fsf@graviton.dyn.troilus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2007 02:30 PM, Michael Poole wrote:
> Florin Malita writes:
>
>   
>> On 06/15/2007 12:18 PM, Michael Poole wrote:
>>     
>>> Yes.  If I cut a book in half and store the halves separately, does
>>> the second half become an independent work?  
>>>       
>> Except in this case you're not touching the book at all. If you write
>> a review for a book (much better analogy methinks), then your review
>> is obviously not an integral part of the book even though it's based
>> on its content.
>>     
>
> Extremely poor analogy.  I do not distribute my review with the book.
>   

But you do (because I say so ; ), and guess what? It makes no 
difference: your review is not a derivative work anymore than it was before.

> Someone buying the book is able to use the book just fine (for the
> purpose for which it was sold) without my review.  They need neither
> my review nor other modifications before the book becomes readable.
>   

Exactly. So what's your difficulty in downloading the Tivo code, reading 
it and re-using it in your own projects, on your other devices? How is 
the missing signing key preventing you from doing any of that?

Someone buying the book may be free to read it anywhere but if they 
insist on reading it at your table you may sensibly require they bring a 
copy of your review with them (to prove their genuine interest ; ). 
Failure to comply only means they have to read the book someplace else. 
Can they read the book? Sure. Can they read it at your table? Only if 
you choose to allow them.

> As Ingo said, you need either the digital signature or other changes
> before a Tivo kernel image will load.
>   

GPLv2 guarantees that the book remains readable. It does not grant you 
(doesn't even try) the right to execute a modified copy on any 
particular piece of hardware. Your kernel is perfectly functional on any 
platform that supports it - it just so happens that the Tivo device does 
not support it.

>> Being an integral part (as in combined or derived work) has nothing to
>> do with usability. There are many other bits and pieces your
>> executable needs in order to function properly (or at all) but that
>> doesn't make your CPU microcode & electricity provider an integral
>> part of the program, does it?
>>     
>
> No.  Those are independent works.

So is a digital signature. Again, are you arguing the digital signature 
is a derivative work?


>   
>> Luckily, it doesn't really matter what you or I think that
>> "integral-ness" means, all it matters is how copyright law defines a
>> "derivative work" and whether a cryptographic hash is such a
>> thing. Now are you seriously arguing that a hash is a derivative work?
>>     
>
> No.  I explained this before.  Try reading the thread and the GPL.  I
> am not sure where people get the (wrong) idea that the GPL only
> concerns itself with "derivative work[s]".
>   

I guess you'll have to explain again because copyright law and its 
definition of derivative works are the things that make the GPL work:

"0.This License applies to any program or other work which contains a 
notice placed by the copyright holder saying it may be distributed under 
the terms of this General Public License. The "Program", below, refers 
to any such program or work, and a "work based on the Program" means 
either the Program or any derivative work under copyright law".

What I can't find though is any reference to "integral parts" or your 
taken-for-granted right to run a modified copy of the program on the 
same device used for distribution (or any mention of functionality at 
all for that matter). Actually: "Activities other than copying, 
distribution and modification are not covered by this License; they are 
outside its scope".

>>>   On top of this, in the Tivo
>>> case the two are distributed together, and even part of the same file.
>>>   
>>>       
>> It's mere aggregation, but it's totally irrelevant because they could
>> just as easily change their approach.
>>     
>
> If and when they do, I'll consider the rules that might apply.  Until
> then, it is fairly stupid to try to defend Tivo by saying they *might*
> do something they currently don't, and if they did, they *might* have
> a defense that they currently don't.
>   

But you're missing the whole point: the rules are the same, nothing 
changes! You are drawing an artificial distinction between the two cases 
and focusing on aggregation, which is totally irrelevant: either the 
digital signature is a derivative work or it isn't, and in either case 
its distribution method makes no difference in the world.

The reason I brought up the separate-signature example is to illustrate 
just how ridiculous is to think of the signature keys as source files: 
you can implement an equivalent DRM system without ever modifying the 
kernel blob. Only difference is the channel used for signature 
distribution, and I hope you won't argue that mere aggregation changes 
its nature.

---
fm
