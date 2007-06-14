Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbXFNSO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbXFNSO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbXFNSOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:14:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44228 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724AbXFNSOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:14:51 -0400
Date: Thu, 14 Jun 2007 11:14:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexandre Oliva <aoliva@redhat.com>
cc: Adrian Bunk <bunk@stusta.de>, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <orsl8ue7ou.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <alpine.LFD.0.98.0706141106540.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr>
 <alpine.LFD.0.98.0706131456230.14121@woody.linux-foundation.org>
 <orejkfla3l.fsf@oliva.athome.lsd.ic.unicamp.br> <200706131946.15714.dhazelton@enter.net>
 <20070614004419.GL3588@stusta.de> <alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org>
 <ortztbgi03.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706140817520.14121@woody.linux-foundation.org>
 <orsl8ue7ou.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Alexandre Oliva wrote:
> 
> > In other words, Red Hat distributes copies (and yes, you *get* that copy), 
> > and you cannot modify that copy that you got.
> 
> And Red Hat can't either.  I thought that was quite obvious.

That's TOTALLY IRRELEVANT!

There is no language in the GPLv2 (only in the GPLv3 drafts) about "same 
upgradability as third parties".

You're arguing a point that DOES NOT EXIST in the GPLv2.

The GPLv2 talks about specific rights, like the ability to make changes 
and distribute things, and says that you have to give downstream all those 
same rights.

And I've pointed out to you (now about five times) that those rights 
CANNOT be able "in-place", since even Red Hat does not actually give you 
the right to do in-place modification of the software they sell.

> The 'passing on the rights you have' makes it an issue.

No. It does not.

I have extra rights as a copyright holder, and that "the rights you have" 
are as they pertain to the software under the GPLv2, not as it pertains to 
the physical device, or outside the GPLv2.

For example, for any code that I have full copyright over, I have rights 
that you DO NOT HAVE! I have the right to re-license it under some other 
license. The fact that I pass on a copy of the software to you under the 
GPLv2 does *not* give you those rights, but that's not even what the GPLv2 
asks for!

The GPLv2, when it talks about "passing on the rights", talks about the 
rights you got *per*the*GPLv2*. 

Any other reading is nonsensical, since the copyrigth owner *always* has 
more rights than a licensee! I legally literally *couldn't* pass over all 
the rights I have to my software! If you read the GPLv2 as meaning that I 
have to, you are mis-reading it. It's that simple.

Anyway, I'm not interested in continuing this flame war.

The fact is, the license for the kernel is the GPLv2. And I think it's a 
superior license. As such, I'd be a total moron to relicense the kernel 
under what I believe is a worse license.

So if you want to argue that I should re-license, you should argue that 
the GPLv3 is better. And quite frankly, you haven't.

		Linus
