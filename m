Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbXFUG33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbXFUG33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 02:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbXFUG3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 02:29:20 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:33738
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXFUG3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 02:29:19 -0400
Date: Wed, 20 Jun 2007 23:29:29 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alexandre Oliva <aoliva@redhat.com>
cc: Michael Poole <mdpoole@troilus.org>, Tomas Neme <lacrymology@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <orir9hrge3.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <Pine.LNX.4.64.0706202326110.31603@asgard.lang.hm>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org>
 <ork5u1awtq.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org>
 <or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>
 <orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
 <9a8748490706201034j43139301w5a18c172d688c724@mail.gmail.com>
 <2e6659dd0706201110x20fa5c28n5d6fc094e9f5c832@mail.gmail.com>
 <871wg6trnx.fsf@graviton.dyn.troilus.org> <2e6659dd0706201205i52e0b836oe642e2b442e425d7@mail.gmail.com>
 <87wsxysaad.fsf@graviton.dyn.troilus.org> <Pine.LNX.4.64.0706201232290.30395@asgard.lang.hm>
 <87odjas9f7.fsf@graviton.dyn.troilus.org> <Pine.LNX.4.64.0706201241060.30395@asgard.lang.hm>
 <ortzt2rmuk.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706202106040.31603@asgard.lang.hm>
 <orir9hrge3.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Alexandre Oliva wrote:

> On Jun 21, 2007, david@lang.hm wrote:
>
>> On Thu, 21 Jun 2007, Alexandre Oliva wrote:
>>> On Jun 20, 2007, david@lang.hm wrote:
>>>
>>>> but the signature isn't part of the kernel, and the code that checks
>>>> the signature is completely independant.
>>>
>>> Well, then remove or otherwise mangle the signature in the disk of
>>> your TiVo DVR and see at what point the boot-up process halts.
>
>> I have actually done exactly that. what happens is that the bootloader
>> detects a problem and switches to the other active partition ane
>> reboots. ir neither of the boot partitions meet the requirements the
>> cycle will continue forever.
>
> Oh, too bad.  That must be a bug in the boot loader, right? :-)
>
>
> BTW, since you got a TiVo...  I'm writing an article on Tivoization,
> could you (or anyone else) please help me get information as to what
> other GPLed programs or libraries TiVo includes in their devices?
>
> Thanks in advance,

frankly, I haven't checked the licenses on the software. I'd suggest going 
to www.tivo.com/linux and download all the source for all the different 
versions there.

by the way, it looks like there is one wireless driver that they ship in 
some releases but don't provide the source for. but if you plan on going 
after them for that you better go after everyone who ships binary kernel 
modules.

David Lang
