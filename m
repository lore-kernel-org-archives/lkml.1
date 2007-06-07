Return-Path: <linux-kernel-owner+w=401wt.eu-S936302AbXFGUVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936302AbXFGUVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765854AbXFGUVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:21:21 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:53504 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764845AbXFGUVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:21:20 -0400
Date: Thu, 07 Jun 2007 16:21:00 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Linux 2.6.22-rc4
In-reply-to: <Pine.LNX.4.64.0706071853080.15778@fbirervta.pbzchgretzou.qr>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>
Message-id: <200706071621.00687.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org>
 <200706071206.06298.gene.heskett@gmail.com>
 <Pine.LNX.4.64.0706071853080.15778@fbirervta.pbzchgretzou.qr>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 June 2007, Jan Engelhardt wrote:
>On Jun 7 2007 12:06, Gene Heskett wrote:
>>On Thursday 07 June 2007, Jan Engelhardt wrote:
>>>On Jun 7 2007 11:24, Gene Heskett wrote:
>>>>>>> It is too stable for me.
>>>>>>
>>>>>>I wish all our testers were you ;)
>>>>>
>>>>>It [2.6.22-rc4] did not die on me so far, unlike that stock FC7 kernel
>>>>>(same config but without fc patches).
>>>>
>>>>Oh its stable allright, but why do I have to turn the monitor off by hand
>>>> when I leave.  None of that is working, not even the screen blanker.
>>>
>>>VC or X?
>>
>>Regular X
>
>Most likely an X incompatibility then?
>
>> fc6 box, amd xp2800.  Using NVIDIA's latest driver, and it works
>>when booted to a 2.6.21 era kernel.
>
>Well, NVIDIA is your first stop then. What about nv?
>
>
>
>	Jan

Don't know Jan.  nv, the last time I tried that bucket of molasses in january, 
couldn't drive this card at more than 800x600, and I am used to double that 
both ways.

The last time I booted to nv, it took me a week to get all the crap fixed that 
it overwrote trying to fit the default screens I use while trying to make 
them fit in an 800x600 window.

I run 1600x1200, on either an ati card (but the radeon driver quit supporting  
the r280 chipset according to boot messages, the main reason I bought this 
nvidia card) or on an older nvidia card that nv was quite happy with.  That 
card went belly up and took the motherboard with it 2 years ago though.

Did you miss the comment that it works with a 2.6.21ish kernel?  Everything 
else being equal.  I will boot to one of them later tonight and test it to 
make sure its not some update to kde though, and let the list know.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Vote anarchist.
