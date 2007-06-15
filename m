Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbXFOSLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbXFOSLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbXFOSLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:11:24 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:44032 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbXFOSLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:11:23 -0400
Message-ID: <4672D648.7020700@dgreaves.com>
Date: Fri, 15 Jun 2007 19:11:20 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Michael Gerdau <mgd@technosis.de>,
       Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <200706142049.41819.dhazelton@enter.net> <200706150825.15491.mgd@technosis.de> <200706150520.15086.dhazelton@enter.net> <46726793.1020206@dgreaves.com> <alpine.LFD.0.98.0706151004460.14121@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706151004460.14121@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 15 Jun 2007, David Greaves wrote:
>> Surely it's more:
>>   bad == go away and don't use future improvements to our software anymore
>> please.
>> ??
> 
> Well, with the understanding that I don't think that what Tivo did was bad 
> in the first place, let me tackle that question *anyway*.
> 
> The answer is: Not necessarily.
I do agree with what you say here. Maybe a summary:
Babies, bathwater...
When you have a hammer (license) everything looks like a nail...

> See? You don't actually have to like Tivo to see downsides to trying to 
> stop them. Because these kinds of things have consequences *outside* of 
> just stopping Tivo.

My concern is around embedded type systems and maybe even the 'trusted' 
frameworks etc.

I _think_ I can see a completely opensource system that the end user cannot 
modify _in any way_. Which kinda defeats the point (to me) of opensource.

This 5 minute design undoubtedly has flaws but it shows a direction:
A basically standard 'De11' PC with some flash.
A Tivoised boot system so only signed kernels boot.
A modified kernel that only runs (FOSS) executables whose signed hash lives in 
the flash.

Do we (you) _want_ to prevent this?

Do we trust in 'the market' to prevent this?

Do we use license tools?

David

