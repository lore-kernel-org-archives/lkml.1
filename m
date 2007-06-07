Return-Path: <linux-kernel-owner+w=401wt.eu-S1763026AbXFGQyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763026AbXFGQyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933800AbXFGQyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:54:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:1544 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933791AbXFGQyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:54:13 -0400
Date: Thu, 7 Jun 2007 18:54:11 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Gene Heskett <gene.heskett@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: Linux 2.6.22-rc4
In-Reply-To: <200706071206.06298.gene.heskett@gmail.com>
Message-ID: <Pine.LNX.4.64.0706071853080.15778@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org>
 <200706071124.30128.gene.heskett@gmail.com>
 <Pine.LNX.4.64.0706071738240.13101@fbirervta.pbzchgretzou.qr>
 <200706071206.06298.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 7 2007 12:06, Gene Heskett wrote:
>
>On Thursday 07 June 2007, Jan Engelhardt wrote:
>>On Jun 7 2007 11:24, Gene Heskett wrote:
>>>>>> It is too stable for me.
>>>>>
>>>>>I wish all our testers were you ;)
>>>>
>>>>It [2.6.22-rc4] did not die on me so far, unlike that stock FC7 kernel
>>>>(same config but without fc patches).
>>>
>>>Oh its stable allright, but why do I have to turn the monitor off by hand
>>> when I leave.  None of that is working, not even the screen blanker.
>>
>>VC or X?
>
>Regular X

Most likely an X incompatibility then?

> fc6 box, amd xp2800.  Using NVIDIA's latest driver, and it works 
>when booted to a 2.6.21 era kernel.

Well, NVIDIA is your first stop then. What about nv?



	Jan
-- 
