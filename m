Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXCZHX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXCZHX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 03:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbXCZHX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 03:23:26 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:35604 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbXCZHX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 03:23:26 -0400
Message-ID: <46077358.70006@student.ltu.se>
Date: Mon, 26 Mar 2007 09:16:40 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22 patch] more scheduled OSS driver removal
References: <20070324130602.GD752@stusta.de> <4607213B.9070005@student.ltu.se> <20070326014819.GS16477@stusta.de>
In-Reply-To: <20070326014819.GS16477@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Mon, Mar 26, 2007 at 03:26:19AM +0200, Richard Knutsson wrote:
>   
>> Adrian Bunk wrote:
>>     
>>> This patch contains the scheduled removal of OSS drivers that:
>>> - have ALSA drivers for the same hardware without known regressions and
>>> - whose Kconfig options have been removed in 2.6.20.
>>>  
>>>       
>> Sorry for this late respond
>>
>> Is sound/oss/emu10k1/ really ready to be replaced? According to a friend 
>> of mine, who got the hardware, the ALSA still lacks feature provided by 
>> the OSS-driver. He mentioned some sort of programmable memory (forgot 
>> the name for that) with whom you can run small programs to manipulate 
>> the sounds (adding echo and such). Also, he got problems with getting 
>> more accurate control of the volume (guess this is more a userland issue).
>> He seems to have done his homework but only got to pages where other 
>> peoples had the same problem.
>>     

> Current number of regressions in the ALSA emu10k1 driver people gave me 
> numbers of open ALSA bugs for:
>   0
>   
Oh ok, I will let him know that. Thanks

Richard Knutsson

