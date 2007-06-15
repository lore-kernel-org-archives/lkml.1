Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbXFORFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbXFORFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbXFORFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:05:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:48074 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbXFORFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:05:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=j+nzLdG/U+M6z/2isNr5nSV2cXkyaH26Ziqvx0p30LpaSh4UshVX6zeUuouJN6ZGf+sBXXfJLqGjmeuQPCd/zw0LzXWiiv/zzLyfGQAv7ZseKt29epvyccxyZQk4xVKfqap5Z+8iGA99J9zaD3vl4tooewcIZaOyg1FX7CRNckM=
Message-ID: <4672C6BA.6020702@gmail.com>
Date: Fri, 15 Jun 2007 13:04:58 -0400
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Michael Poole <mdpoole@troilus.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>	<200706142246.57583.dhazelton@enter.net>	<878xal2a0q.fsf@graviton.dyn.troilus.org>	<200706150127.18069.dhazelton@enter.net>	<87sl8tzaj1.fsf@graviton.dyn.troilus.org>	<20070615124039.GB21120@elte.hu>	<87fy4tz8dc.fsf@graviton.dyn.troilus.org>	<20070615143003.GA8775@elte.hu>	<87zm31xo3q.fsf@graviton.dyn.troilus.org> <4672B5F6.706@gmail.com> <87r6odxkbc.fsf@graviton.dyn.troilus.org>
In-Reply-To: <87r6odxkbc.fsf@graviton.dyn.troilus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2007 12:18 PM, Michael Poole wrote:
> Florin Malita writes:
>
>   
>> On 06/15/2007 10:56 AM, Michael Poole wrote:
>>     
>>> The GPL cares about the key
>>> used to generate an integral part of the executable form of the GPLed
>>> work.  
>>>       
>> GLPv2 doesn't: why do you think the digital signature is an integral
>> part of the executable? It can be a totally separate blob, distributed
>> via a separate channel and even stored at a different location than
>> the executable. Does it still look like an integral part of the
>> executable to you then?
>>     
>
> Yes.  If I cut a book in half and store the halves separately, does
> the second half become an independent work?  

Except in this case you're not touching the book at all. If you write a 
review for a book (much better analogy methinks), then your review is 
obviously not an integral part of the book even though it's based on its 
content.

> The integral-ness is a
> function of how the thing is created and how it functions, not how it
> is stored.  If you need part B for part A to execute as intended, then
> part A is not a complete work in itself.

Being an integral part (as in combined or derived work) has nothing to 
do with usability. There are many other bits and pieces your executable 
needs in order to function properly (or at all) but that doesn't make 
your CPU microcode & electricity provider an integral part of the 
program, does it?

Luckily, it doesn't really matter what you or I think that 
"integral-ness" means, all it matters is how copyright law defines a 
"derivative work" and whether a cryptographic hash is such a thing. Now 
are you seriously arguing that a hash is a derivative work?

>   On top of this, in the Tivo
> case the two are distributed together, and even part of the same file.
>   

It's mere aggregation, but it's totally irrelevant because they could 
just as easily change their approach.

---
fm
