Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbXFQVOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbXFQVOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbXFQVOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:14:06 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:45883
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbXFQVOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:14:02 -0400
Date: Sun, 17 Jun 2007 14:13:30 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alexandre Oliva <aoliva@redhat.com>
cc: Bernd Petrovitsch <bernd@firmix.at>, Gabor Czigola <czigola@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <orfy4qffyj.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <Pine.LNX.4.64.0706171408260.31541@asgard.lang.hm>
References: <3a0f49600706171014m6bc9af34s9dda0ea282a4d63@mail.gmail.com>
 <orfy4qh0mc.fsf@oliva.athome.lsd.ic.unicamp.br> <1182112097.3800.3.camel@gimli.at.home>
 <orfy4qffyj.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

you argue that it is evil for tivo to produce a pice of hardware that they 
can modify and the user can't

but you then argue that it's a good thing for the FSF to produce a license 
that they can modify and others can't

in the first case tivo is limiting their hardware, releases all the 
source for the software under the license, and makes it very clear that 
this is the case before anyone buys a box.

in the second case the FSF is trying to convince everyone that anyone who 
produced code under the fist license, but didn't give the FSF the ability 
to relicense their code to whatever the FSF wants are misguided fools who 
just don't understand what they are doing.

I for one see what tivo is doing as being much less evil then what the FSF 
is doing.

David Lang

On Sun, 17 Jun 2007, Alexandre Oliva wrote:

> Date: Sun, 17 Jun 2007 18:07:00 -0300
> From: Alexandre Oliva <aoliva@redhat.com>
> To: Bernd Petrovitsch <bernd@firmix.at>
> Cc: Gabor Czigola <czigola@gmail.com>, lkml <linux-kernel@vger.kernel.org>
> Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
> 
> On Jun 17, 2007, Bernd Petrovitsch <bernd@firmix.at> wrote:
>
>> On Sun, 2007-06-17 at 15:55 -0300, Alexandre Oliva wrote:
>>> On Jun 17, 2007, "Gabor Czigola" <czigola@gmail.com> wrote:
>>>
>>>> I wonder why the linux kernel development community couldn't propose
>>>> an own GPL draft (say v2.2) that is "as free as v2" and that includes
>>>> some ideas (from v3) that are considered as good (free, innovative, in
>>>> the spirit of whatever etc.) by the majority of the kernel developers.
>>>
>>> For one, because the text of the GPL is copyrighted by the FSF, and
>>> licensed without permission for modification.  And that's as it should
>>> be, you don't want others to modify the terms of the license you chose
>>> for your code, do you?
>
>> That's probably precisely the reason for removing the "or later" so that
>> others (even if it's "only" the FSF) can't modify the terms of the
>> license chosen for the code.
>
> Yes, if you don't trust the organization entitled to publish revised
> versions to abide by its commitment to abide by a similar spirit, or
> if that spirit does not reflect your intent as a copyright holder,
> this are all rational reasons to remove the "or later", indeed (at
> least as much as distrust can be regarded as rational, that is ;-)
>
>
> However, as Ingo argued, not being able to patch holes, fix bugs and
> add new features is a very bad idea.  He was talking about the
> software, but this is as true when it comes to the license.
>
> There are smarter ways of retaining control over licensing terms that
> don't paint yourself into a corner that's nearly impossible to get out
> of.
>
> For example, the license provisions could state "or any later version
> that CONDITION", where CONDITION reflects your intent as a copyright
> holder, or it could state "or any other license that CONDITION."
>
> They could also appoint a committee, or rules for formation of a
> committee, to make this sort of decisions on behalf of all the
> copyright holders involved.
>
> Of course, since these are in fact all additional permissions, anyone
> could take them out, or rather elect not to offer this option for
> their own contributions (and then you might end up refraining from
> merging them).
>
> The mechanics are no different from "or any later version" provisions,
> really, except that then you establish what the goals of your
> community are without blocking upgrades that wouldn't conflict, but
> that would rather further the interests of your own community.
>
>
