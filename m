Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbXFUUCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbXFUUCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbXFUUB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:01:56 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:56463
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbXFUUBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:01:55 -0400
Date: Thu, 21 Jun 2007 13:01:15 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alexandre Oliva <aoliva@redhat.com>
cc: Andrew McKay <amckay@iders.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <ork5txksp0.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <Pine.LNX.4.64.0706211300200.31603@asgard.lang.hm>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
 <orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
 <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
 <orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br> <4679557C.5080907@iders.ca>
 <20070620175627.319a6c55@the-village.bc.nu> <46797C52.4020907@iders.ca>
 <orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706201412340.30395@asgard.lang.hm>
 <ord4zqrl0l.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706202227160.31603@asgard.lang.hm>
 <orejk5rg76.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706202334420.31603@asgard.lang.hm>
 <ory7idpykk.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706210031280.31603@asgard.lang.hm>
 <ork5txksp0.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Alexandre Oliva wrote:

> On Jun 21, 2007, david@lang.hm wrote:
>
>> On Thu, 21 Jun 2007, Alexandre Oliva wrote:
>>> On Jun 21, 2007, david@lang.hm wrote:
>>>
>>>> no, one of the rules for the network is that the software must be
>>>> certified,
>>>
>>> In this case you might have grounds to enforce this restriction of the
>>> network on the network controller itself, I suppose.
>
>> how would the network controller know if the software has been modified?
>
> The loader could check that and set a flag in the controller.
>
>> what sort of signal can the network controller send that couldn't be
>> forged by the OS?
>
> Whatever the network controller designer created to enable it to do
> so.
>
>> how would you do this where the device is a receiver on the netwoek
>> (such as a satellite receiver)
>
> If it's input-only, then you can't possibly harm the operation of the
> network by only listening in, can you?

Ok, so you consider any anti-piracy measures to be something that GPLv3 
should prohibit.

thanks for finally takeing a position.

David Lang
