Return-Path: <linux-kernel-owner+w=401wt.eu-S940782AbXHNCIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940782AbXHNCIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 22:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764630AbXHNCIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 22:08:12 -0400
Received: from host06.hostingexpert.com ([216.80.70.60]:44382 "EHLO
	host06.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764583AbXHNCIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 22:08:10 -0400
Message-ID: <46C10E85.2070902@linuxtv.org>
Date: Mon, 13 Aug 2007 22:08:05 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Manu Abraham <abraham.manu@gmail.com>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] [534/2many] MAINTAINERS -	VIDEO
 FOR LINUX
References: <46bffca0.bx1Cr4B33dN1FJPN%joe@perches.com>	<1187028910.664.11.camel@gaivota>	<1187030038.10249.237.camel@localhost>	<1a297b360708131222t55be6fbax78a6659762a98e7e@mail.gmail.com> <1187056816.10249.366.camel@localhost>
In-Reply-To: <1187056816.10249.366.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host06.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Mon, 2007-08-13 at 23:22 +0400, Manu Abraham wrote:
>   
>>> F:      drivers/media/
>>>       
>> This means everything under media is maintained under V4L. Incorrect
>>     
>
> What would you like?
>
>   
Just dont list "drivers/media".

Instead:

drivers/media/video  -- v4l
drivers/media/radio  -- v4l


drivers/media/dvb   -- dvb

Cheers,

Michael Krufky
