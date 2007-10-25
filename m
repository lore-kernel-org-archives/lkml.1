Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbXJYMiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbXJYMiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 08:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbXJYMhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 08:37:52 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51875 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbXJYMhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 08:37:51 -0400
Message-ID: <47208E0E.10408@linux.vnet.ibm.com>
Date: Thu, 25 Oct 2007 18:07:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: WANG Cong <xiyou.wangcong@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86 patch] Fix UML ubd_kern.c build error
References: <20071025115020.30481.60740.sendpatchset@balbir-laptop> <20071025120807.GD2459@hacking>
In-Reply-To: <20071025120807.GD2459@hacking>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong wrote:
> On Thu, Oct 25, 2007 at 05:20:20PM +0530, Balbir Singh wrote:
>>
>> Fix UML build error, include linux/scatterlist.h in arch/um/drivers/ubd_kern.c,
>> to resolve the definition of sg_page()
>>
>> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> This is already fixed by me[1]. ;)
> 
> [1] http://lkml.org/lkml/2007/10/24/86
> 
> Regards.
> 

Excellent! Thanks for pointing me to the fix


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
