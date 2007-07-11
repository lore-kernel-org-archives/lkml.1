Return-Path: <linux-kernel-owner+w=401wt.eu-S1765653AbXGKRwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765653AbXGKRwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbXGKRvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:51:52 -0400
Received: from pool-70-109-119-137.alb.east.verizon.net ([70.109.119.137]:50258
	"EHLO gaimboi.tmr.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756551AbXGKRvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:51:51 -0400
Message-ID: <46951969.4030109@tmr.com>
Date: Wed, 11 Jul 2007 13:54:49 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@stusta.de>,
       Zhang Rui <rui.zhang@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the scheduled ACPI_PROCFS removal
References: <20070709145755.GD3492@stusta.de> <20070709174544.2a6b7067@the-village.bc.nu> <Pine.LNX.4.64.0707092044520.2887@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707092044520.2887@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jul 9 2007 17:45, Alan Cox wrote:
>>> This patch contains the scheduled removal of the ACPI procfs interface.
>> What part of "we do not gratuitously break user space interfaces" is so
>> hard for people to understand.
> 
> Generally I am with you on that, but if everyone keeps on using /proc --
> and I do[*] -- we will never get rid of it.
> 
Is there some reason why you should get rid of it? Is it causing a lot 
work to maintain?
> 
> [*] Does someone have an alternative for /proc/acpi/battery/BAT1/{state,info}?
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
