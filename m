Return-Path: <linux-kernel-owner+w=401wt.eu-S933460AbYD3VvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460AbYD3VvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759248AbYD3Vux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:50:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:35060 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762153AbYD3Vuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:50:51 -0400
Date: Wed, 30 Apr 2008 23:51:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: dmitri.vorobiev@gmail.com, mingo@elte.hu, tglx@linutronix.de,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove NexGen support (fwd)
Message-ID: <20080430215133.GE18536@elf.ucw.cz>
References: <20080429081729.GA3921@ucw.cz> <20080430213457.GD18536@elf.ucw.cz> <4818E777.2070702@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4818E777.2070702@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-04-30 14:41:11, H. Peter Anvin wrote:
> Pavel Machek wrote:
>> Hi!
>>
>>> It is claimed that NexGen CPUs were never shipped:
>>>
>>> http://lkml.org/lkml/2008/4/20/179
>>>
>>> Also, the kernel support for these chips has been broken for
>>> a long time, the code intended to support NexGen thereby being
>>> essentially dead.
>>
>> Are you sure it never shipped? Wikipedia seems to suggest it did ship.
>>
>> http://www.cpu-info.com/index2.php?mainid=Nx586&page=5
>>
>> ...FPU for nexgen was never shipped, that implies that CPU did ship.
>>
>
> Doesn't mean it shipped in anything other than sample or sample-like 
> quantities.

http://www.cpu-info.com/index2.php?mainid=Nx586&page=7

I do not know how many were really shipped, and yes, they seem to be
pretty uncommon, but it sounds like more than samples. Actually, some
seem to be for sale on ebay ;-).

								Pavel

...
The first NxPCI AT motherboards were shipped at the beginning of
September 1995 after they were first announced in fall
1994. Motherboards featured support for EDO and Fast Page memory up to
768MB DRAM, up to four IDE devices, an on-board floppy controller, two
serial ports and one parallel. It had four ISA slots and three PCI
slots. Prices for a complete configuration, motherboard, CPU and
heatsink were at $339 in combination with the Nx586 P90 and $439 with
a P100.

...
With a big player like Intel, getting a foothold in the processor
business is hard. To gain the buyers attention continues price drops
had to be made. By the time the Nx586 was actually for sale, the entry
Nx586-P75 cost $404, the P80 $477, $539 for the P90 and the P100 was
priced at $777. With new price cuts in mind Nexgen sought ways to
reduce costs. One way was to make production of the Nx586 more
efficient, fit more die's on a wafer. A die shrink was announced in
the first half of 1995.
...

Nexgen discontinued its Nx586 P75 and P80 around August 1995. Demand
had shifted to higher performance parts and NexGen needed the capacity
for the imminent rollout of its new P120 and P133. Prices were once
again reduced from $299 to $245 for the P90 and from $399 to $340 for
the P100. In the mean time Nexgen was still trying to close additional
deals for the manufacturing of motherboards and chipsets. To date
motherboards were only manufactured by Alaris and chipsets by Fujitsu.

For over a year now Nexgen was shipping FPU less Nx586's, but this was
about to end. In November 1995 Nexgen announced the Nx586 with
integrated FPU, the Nx586 Pf100 and the faster Nx586 Pf120. The CPU
and FPU would packaged together on a Multichip Module and manufactured
by IBM. The Nx586 Pf100 would be available in December and the Pf120
was scheduled for Q1 1996.



									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
