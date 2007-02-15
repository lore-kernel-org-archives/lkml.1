Return-Path: <linux-kernel-owner+w=401wt.eu-S964916AbXBOGva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964916AbXBOGva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 01:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964923AbXBOGv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 01:51:29 -0500
Received: from vms048pub.verizon.net ([206.46.252.48]:56110 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964921AbXBOGv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 01:51:29 -0500
Date: Thu, 15 Feb 2007 01:51:22 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: GPL vs non-GPL device drivers
In-reply-to: <17875.64112.54164.635911@notabene.brown>
To: linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, "v j" <vj.linux@gmail.com>
Message-id: <200702150151.24748.gene.heskett@verizon.net>
Organization: Not detectable
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
 <17875.64112.54164.635911@notabene.brown>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007, Neil Brown wrote:
>On Wednesday February 14, vj.linux@gmail.com wrote:
>> However we have a worrying trend here. If at some point it becomes
>> illegal to load our modules into the linux kernel, then it is
>> unacceptable to us. We would have been better off choosing VxWorks or
>> OSE 3 years ago when we made an OS choice. The fact that Linux is
>> becoming more and more closed is very very alarming.
>
>Might I suggest that you give very serious consideration to
>open-sourcing your drivers?  There are benefits and well as costs, and
>many have found that the benefits substantially out weigh the costs.
>
>NeilBrown

Speaking as one who has not contributed back to the kernel other than an 
occasional bug report as I'm getting too old to code alongside these 
wizards, please let me say:

That's an admirable bit of advice Neil, but I have serious doubts it will 
fall on a fertile mind.  From vj's tone here, its obvious that he thinks 
its fine to leech his income stream from code that is free.  And giving 
one teeny little patch for some utility back seems to make him think he 
has paid the bill.  Methinks he has not paid the bill in kind because its 
an ongoing rental.

Now, if he _were_ to contribute his top secret drivers into the kernel 
tree, how are we to convince vj that it is in his best interest in the 
long run to do so?  After all, the many eyeballs theory will guarantee 
that his codebase will not go untouched because bugs he doesn't even know 
exist will be noticed and fixed, and routine speedups of 2x are entirely 
possible too.  He will in the long run get back faster, more stable code 
which can't do anything but enhance the value of his hardware, both in 
how well it runs, but in the public's perception too, simply because it 
IS in the kernel tree and therefore very well reviewed.  And that vj, is 
an advertising point of no little value. 

But, I suspect by now he has pulled the batteries out of his hearing aid 
so he doesn't have to listen to any more of this blasphemous talk.  
Sad...

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Yahoo.com and AOL/TW attorneys please note, additions to the above
message by Gene Heskett are:
Copyright 2007 by Maurice Eugene Heskett, all rights reserved.
