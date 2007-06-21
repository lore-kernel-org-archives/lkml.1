Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbXFUSBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbXFUSBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758939AbXFUSAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:00:30 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:48450
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759960AbXFUSA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:00:28 -0400
Date: Thu, 21 Jun 2007 11:00:40 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alexandre Oliva <aoliva@redhat.com>
cc: jimmy bahuleyan <knight.camelot@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
In-Reply-To: <orr6o5kxdr.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <Pine.LNX.4.64.0706211055160.31603@asgard.lang.hm>
References: <orlkedpryc.fsf@oliva.athome.lsd.ic.unicamp.br> <467A6290.80602@gmail.com>
 <orr6o5kxdr.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Alexandre Oliva wrote:

> On Jun 21, 2007, jimmy bahuleyan <knight.camelot@gmail.com> wrote:
>
>> There, that right there, wouldn't it again require a 'nod' from all
>> those who have contributed to the kernel (because at the time they did,
>> the license was GPLv2 without any additions)?
>
> That's my understanding, yes, but IANAL.
>
>
> Similarly, any GPLv2 and GPLv3 projects that wish to cooperate with
> each other could introduce mutual additional permissions in the way I
> suggested, even if neither GPLv2 nor GPLv3 themselves make such
> provisions.  This is a decision that copyright holders can make, in
> very much the same way that they can make their decisions as to
> permitting relicensing under newer versions of the GPL, or even older
> versions of the GPL.
>
>
> BTW, I should probably have made clear that, as usual, I was speaking
> my own mind, not speaking on behalf of FSFLA or Red Hat, with whom I'm
> associated, and certainly not on behalf of FSF, with whom I'm not
> associated.  Just in case this wasn't clear yet ;-)

this is standard dual-licensing, not special just becouse both licenses 
are GPL versions

and for people who don't like one or the other of the two licenses this 
will not be acceptable becouse it would allow someone else to take their 
work, modify it a bit, and release the result only under the license that 
they don't like

GPL+exceptions is the same thing, you are releasing it under multiple 
licenses, GPL, GPL + 1st exception, GPL + 2nd exception, GPL + 1st and 2nd 
exception, etc

one of the big problems that people don't realize is that if it takes 
GPLv3+ exception to be compatible with the apache license it's technicaly 
not legal to later strip that exception off becouse the result isn't 
compatible with the apache license, even if the GPL license says that you 
can.

after the code has passed through a couple hands it will be hard for 
someone receiving the code to know this.

I expect a lot of flamage, and bad blood, and possibly a little legal 
action between opensource projects over the next several years as people 
realize their code is being hijacked this way.

David Lang
