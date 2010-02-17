Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819Ab0BQBDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 20:03:50 -0500
Received: from ns3.baby-dragons.com ([64.62.236.141]:45290 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933691Ab0BQBDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 20:03:48 -0500
Date: Tue, 16 Feb 2010 16:03:43 -0900 (AKST)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: Bill Davidsen <davidsen@tmr.com>
cc: Volker Armin Hemmann <volkerarmin@googlemail.com>,
       Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
In-Reply-To: <4B7AD35E.7000405@tmr.com>
Message-ID: <alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com>
References: <201002140251.59668.volkerarmin@googlemail.com> <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com> <201002141940.35716.volkerarmin@googlemail.com> <4B7AD35E.7000405@tmr.com>
User-Agent: Alpine 2.01 (LNX 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (ns3.baby-dragons.com [64.62.236.141]); Wed, 17 Feb 2010 01:03:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 	Hello Bill ,

On Tue, 16 Feb 2010, Bill Davidsen wrote:
> Volker Armin Hemmann wrote:
>> On Sonntag 14 Februar 2010, you wrote:
>>> In other words, 'auto-detection' for 1.x format devices is using an
>>> initrd/initramfs.
>>
>> which makes 1.x format useless for everybody who does not want to deal with 
>> initrd/initramfs.
>
> You make this sound like some major big deal. are you running your own 
> distribution? In most cases mkinitrd does the right thing when you "make 
> install" the kernel, and if you are doing something in the build so complex 
> that it needs options, you really should understand the options and be sure 
> you're doing what you want.
>
> Generally this involves preloading a module or two, and if you need it every 
> time you probably should have built it in, anyway.
>
> My opinion...
 	My Opinion as well .  That is one of the many reasons why I have my '/' 
autoassemble .  And do to this I am permanently stuck at 0.90 version of the 
raid table .  No big shakes for that .  But at sometime in the past there was a 
discussion to have the 0.90 raid table be removed ,  NOW THAT SCARES THE H?LL 
OUT OF ME .  So far Neil has not done so .

 	I am unaware of any record from Neil or other maintainer(s) of the 
/md/ device tree saying that they will not remove the 0.90 table and the 
autoassembly functions there .  I'd very much like to hear a statement saying 
there will not be a removal of the autoassembly functions for 0.90 raid table 
from the kernel tree .

 		Tia ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 3237     Holden Road |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99709 |   only  on  AXP |
+------------------------------------------------------------------+
