Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbYFFLqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbYFFLqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 07:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYFFLpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 07:45:55 -0400
Received: from homer.mvista.com ([63.81.120.155]:49013 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753321AbYFFLpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 07:45:54 -0400
Message-ID: <4849236B.8060100@ru.mvista.com>
Date: Fri, 06 Jun 2008 15:45:47 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: Pierre Ossman <drzeus@drzeus.cx>, ralf@linux-mips.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] Alchemy: export get_au1x00_speed for modules
References: <20080519080339.GA21985@roarinelk.homelinux.net> <20080519080416.GB21985@roarinelk.homelinux.net> <483149E0.6010009@ru.mvista.com> <20080519094953.GA22445@roarinelk.homelinux.net> <20080605230311.7f98cd1a@mjolnir.drzeus.cx> <20080606071646.GA16498@roarinelk.homelinux.net>
In-Reply-To: <20080606071646.GA16498@roarinelk.homelinux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Manuel Lauss wrote:
>>>>> From 8492076e98c7fd47c9dee53984dbd9568ace357d Mon Sep 17 00:00:00 2001
>>>>> From: Manuel Lauss <mlau@msc-ge.com>
>>>>> Date: Wed, 7 May 2008 13:42:55 +0200
>>>>> Subject: [PATCH] Alchemy: export get_au1x00_speed for modules
>>>>>
>>>>> au1xmmc.c driver depends on it, so export it for modules.
>>>>>
>>>>> Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
>>>>>
>>>>>           
>>>>   I thought that has been merged.
>>>>         
>>> Yes, Ralf merged it into linux-mips repo, but it is not yet in
>>> mainline and the rest of the patches are against linus' git.
>>>
>>>       
>> So who should push this to Linus? If this set is the only patches
>> depending on it, it would be easiest if I carry it in my tree.
>>     
>
> I'd prefer if you (Pierre) carried them all since they all depend on
> each other (kind of, anyway).  And it seems Ralf has gone silent anyway :)
>   

   Ralf has pushed this patch to Linus, and it has gone into the Linus' 
tree today.

> Thank you!
> 	Manuel Lauss
>   

WBR, Sergei


