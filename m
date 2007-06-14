Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbXFNRpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbXFNRpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbXFNRpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:45:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750771AbXFNRpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:45:45 -0400
Date: Thu, 14 Jun 2007 10:44:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Alexandre Oliva <aoliva@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070614171504.GT3588@stusta.de>
Message-ID: <alpine.LFD.0.98.0706141036460.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <200706132140.13490.dhazelton@enter.net>
 <20070614020827.GO3588@stusta.de> <200706132243.14651.dhazelton@enter.net>
 <20070614025640.GQ3588@stusta.de> <9578.1181793617@turing-police.cc.vt.edu>
 <20070614152034.GS3588@stusta.de> <alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org>
 <20070614171504.GT3588@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Adrian Bunk wrote:
> 
> I'm wondering more and more why you choose the GPL and not the BSD 
> licence for the Linux kernel...

Why do people confuse "anti-GPLv3" with "pro-BSD"?

What's the logic?

The BSD license is not doing tit-for-tat. It doesn't give me anything 
back. I don't believe in that kind of model. So I'd not use it for my 
projects.

The GPLv2 has a good balance. It encourages tit-for-tat, and it makes sure 
that the software is kept free. And it doesn't try to force anything else, 
or play politics. The only thing you have to believe in is "tit-for-tat".

The GPLv3 goes too far. It's no longer "tit-for-tat", it's "our software 
is worth _soo_ much, that we want to force you to behave well, or you 
cannot use it".

I think one of the above licenses are good. The fact that I reject the 
GPLv3 in _no_ way implies that I should like the BSD license. Both the BSD 
license and the GPLv3 are flawed - they are just flawed in fundamentally 
different ways.

So the whole question of "why don't you use he BSD license then" is just 
fundamentally bogus. A license is about a *balance* of things. "Fairness" 
is not about laissez-faire (BSD) or about total-control (GPLv3). To me, 
It's about something in the middle, where people give back in kind.

And btw, that "to me" is important. 

Different people have different opinions. That's _fine_. Use the GPLv3 for 
your projects. Go wild. Use the BSD license. It's your choice. 

But by the same token, it was _my_ choice (and it was an informed choice) 
to use the GPLv2. 

And to then come in fifteen years later and call me "confused" about a 
license I've chosen is a damn affront to me. I'm not confused. Somebody 
else may be, but it's not me.

		Linus
