Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbXFUH3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbXFUH3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 03:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbXFUH3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 03:29:39 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:34646
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbXFUH3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 03:29:38 -0400
Date: Thu, 21 Jun 2007 00:29:47 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alexandre Oliva <aoliva@redhat.com>
cc: Michael Poole <mdpoole@troilus.org>, Tomas Neme <lacrymology@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <or3b0lrdb5.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <Pine.LNX.4.64.0706210024340.31603@asgard.lang.hm>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
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
 <orir9hrge3.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706202326110.31603@asgard.lang.hm>
 <or3b0lrdb5.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Alexandre Oliva wrote:

> On Jun 21, 2007, david@lang.hm wrote:
>
>> frankly, I haven't checked the licenses on the software. I'd suggest
>> going to www.tivo.com/linux and download all the source for all the
>> different versions there.
>
> Yeah, thanks, I remembered someone had posted that URL the second
> after a hit Send :-(
>
> I've already got cmd.tar.gz and I'm looking at it now.
>
> Thanks again,
>
>> by the way, it looks like there is one wireless driver that they ship
>> in some releases but don't provide the source for. but if you plan on
>> going after them for that you better go after everyone who ships
>> binary kernel modules.
>
> Only copyright holders of Linux can go after them on matters of kernel
> drivers.  Or is this driver derived from any software copyrighted by
> myself?  Or did you mean the FSF, with whom I'm not associated in any
> way other than ideologically?

from the page listed above

NOTE: 4.0.1a and later releases contain Atmel WLAN drivers in addition to 
the other network adapter drivers that are posted here. These WLAN drivers 
were received by TiVo directly from Atmel and are under the terms of a 
formal non-disclosure agreement, so we cannot publish them under the terms 
of the GPL version 2. Atmel has since released a different version of the 
drivers under the GPL version 2; however, that release does not change our 
prior obligation with Atmel. At this time, we have no plans to use Atmel's 
publicly released drivers in our development.

when I talked about 'going after tivo' I wasn't just refering to doing so 
with lawsuits. the way some people in this thread have acted I could see 
people trying to use this as 'the smoking gun' that proves that the evil 
tivo people didn't release everything they were supposed to.

modules are a grey area, some are clearly derived from the kernel and some 
are just as clearly not derived from the kernel, most are not as clear. I 
don't know the situation for this particular module, but that has nothing 
to do with this topic.

David Lang
