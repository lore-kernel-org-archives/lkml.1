Return-Path: <linux-kernel-owner+w=401wt.eu-S1761110AbYBNRml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761110AbYBNRml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 12:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbYBNRmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 12:42:33 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:46384
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbYBNRmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 12:42:32 -0500
Message-ID: <47B47D85.9070504@qumranet.com>
Date: Thu, 14 Feb 2008 19:42:29 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates
References: <20080213155725.GA19523@elte.hu> <661de9470802130819i61dfe317jf3725a49d8a314b4@mail.gmail.com> <20080214162510.GA29570@elte.hu>
In-Reply-To: <20080214162510.GA29570@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>   
>> Ingo, could you also please consider the KVM build fix at 
>> http://marc.info/?l=linux-kernel&m=120262794315024&w=2 which has been 
>> acked by Avi. I suspect this patch should be route through git-x86 
>> since it affects arch/x86/Kconfig.
>>     
>
> thanks, applied - this first looked like a KVM item, that's why i havent 
> added it. [Btw., feel free to push it via kvm.git as well - as long as 
> you are sure it does not break the build ;-) ]	

Yeah, I'm queuing it as well, it will get there one way or the other.

-- 
error compiling committee.c: too many arguments to function

