Return-Path: <linux-kernel-owner+w=401wt.eu-S2992943AbXCIESu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992943AbXCIESu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 23:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992944AbXCIESu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 23:18:50 -0500
Received: from mail.tmr.com ([64.65.253.246]:33386 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992943AbXCIESt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 23:18:49 -0500
Message-ID: <45F0E0BD.2090204@tmr.com>
Date: Thu, 08 Mar 2007 23:21:17 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
   scheduler
References: <54348.192.54.193.51.1173087934.squirrel@rousalka.dyndns.org> <200703050453.08154.gene.heskett@gmail.com> <45EDA9DF.6030305@tmr.com> <200703070706.41676.kernel@kolivas.org>
In-Reply-To: <200703070706.41676.kernel@kolivas.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Wednesday 07 March 2007 04:50, Bill Davidsen wrote:

>> With luck I'll get to shake out that patch in combination with kvm later
>> today.
> 
> Great thanks!. I've appreciated all the feedback so far.
> 
I did try, the 2.6.21-rc3-git3 doesn't want to kvm for me, and your 
patch may not be doing what it should. I'm falling back to 2.6.20 and 
will retest after I document my kvm issues.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
