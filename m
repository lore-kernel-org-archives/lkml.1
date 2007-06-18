Return-Path: <linux-kernel-owner+w=401wt.eu-S933049AbXFRVxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049AbXFRVxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763936AbXFRVxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:53:09 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:48493
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762697AbXFRVxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:53:08 -0400
Date: Mon, 18 Jun 2007 14:52:19 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alexandre Oliva <aoliva@redhat.com>
cc: Anders Larsen <al@alarsen.net>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <orlkeh9btt.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <Pine.LNX.4.64.0706181447430.14890@asgard.lang.hm>
References: <1182156596l.29108l.0l@ecxwww1.reanet.de>
 <or1wg9ccyd.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706181202580.12717@asgard.lang.hm>
 <orbqfdavpn.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706181343320.14890@asgard.lang.hm>
 <orlkeh9btt.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Alexandre Oliva wrote:

> On Jun 18, 2007, david@lang.hm wrote:
>
>> On Mon, 18 Jun 2007, Alexandre Oliva wrote:
>>> On Jun 18, 2007, david@lang.hm wrote:
>>>
>>>> they want to prevent anyone from modifying the credit card machine to
>>>> store copies of all the card info locally.
>>>
>>> I see.  Thanks for enlightening me.
>>>
>>>> you don't really answer this issue. since these boxes are required to
>>>> be sealed and physically anti-tamper, changing the ROM is not
>>>> acceptable.
>>>
>>> Given the ROM exception in GPLv3, I guess you could seal and
>>> anti-tamper it as much as you want, and leave the ROM at such a place
>>> in which it's easily replaceable but with signature checking and all
>>> such that the user doesn't install ROM that is not authorized by you.
>
>> 'sealed, but easy to replace ROM containing the programming' is a
>> contridiction.
>
>> if a local person can easily replace the programming it doesn't meet
>> the PCI requirements and therefor you just cannot use GPLv3 code for
>> this sort of application.
>
> How can someone easily replace the programming if there's signature
> checking and all?
>
> The sealing of the ROMmed software is accomplished by other means, but
> it's there.  I shall mention that I'm not endorsing or recommending
> this practice, it might very well be copyright infringement even under
> GPLv1 and v2.

Ok, next question, could you do the same thing if you used a CD instead of 
a ROM?

what makes a blob delivered via a network inherently different from the 
same blob delivered via a plugin ROM or CD?

David Lang
