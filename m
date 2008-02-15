Return-Path: <linux-kernel-owner+w=401wt.eu-S1765722AbYBODdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765722AbYBODdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 22:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbYBODdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 22:33:08 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:59262 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYBODdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 22:33:06 -0500
Message-ID: <47B5073B.9070802@linux.vnet.ibm.com>
Date: Fri, 15 Feb 2008 09:00:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20071129)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates
References: <20080213155725.GA19523@elte.hu> <661de9470802130819i61dfe317jf3725a49d8a314b4@mail.gmail.com> <20080214162510.GA29570@elte.hu> <47B47D85.9070504@qumranet.com>
In-Reply-To: <47B47D85.9070504@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Ingo Molnar wrote:
>> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>
>>  
>>> Ingo, could you also please consider the KVM build fix at
>>> http://marc.info/?l=linux-kernel&m=120262794315024&w=2 which has been
>>> acked by Avi. I suspect this patch should be route through git-x86
>>> since it affects arch/x86/Kconfig.
>>>     
>>
>> thanks, applied - this first looked like a KVM item, that's why i
>> havent added it. [Btw., feel free to push it via kvm.git as well - as
>> long as you are sure it does not break the build ;-) ]   
> 
> Yeah, I'm queuing it as well, it will get there one way or the other.
> 

Excellent! :)

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
