Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbYEXAjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbYEXAjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 20:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYEXAjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 20:39:35 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61131 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYEXAje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 20:39:34 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5302"; a="3213747"
Message-ID: <483763BE.40800@qualcomm.com>
Date: Fri, 23 May 2008 17:39:26 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: rdunlap@xenotime.net, mingo@elte.hu, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [PATCH] [genirq] Expose default irq affinity mask
References: <1211571995-17488-1-git-send-email-maxk@qualcomm.com>	<20080523134702.e5fb9145.rdunlap@xenotime.net>	<48372E2E.4020902@qualcomm.com> <20080523175447.e0c69591.pj@sgi.com>
In-Reply-To: <20080523175447.e0c69591.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max, replying to Randy:
>>> Documentation, perhaps an update to Documentation/filesystems/proc.txt ?
>> Absolutely. I wanted to see if it gets accepted first.
> 
> For new features such as this, documentation is helpful in reviewing.
> 
> (For me at least, documentation is even helpful in -writing- the code,
> as I find that if I can't explain something in words clearly and
> accurately, then my code is probably confused as well.  However, I'm
> obviously weird, and not just in this regard.)
> 
>>From what I can tell, it's ok.  I look forward to seeing the Documentation,
> and will review it again at that time.
> 

There is not going to be whole a lot of documentation for this. Basically the 
commit comment is what will be in the documentation.
In other words I do not think it'll help you with the review.

Max



