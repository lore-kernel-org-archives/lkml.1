Return-Path: <linux-kernel-owner+w=401wt.eu-S1751297AbZC0L0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbZC0L0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZC0L0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:26:25 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57175 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbZC0L0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:26:24 -0400
Message-ID: <49CCB7DB.8050703@petalogix.com>
Date: Fri, 27 Mar 2009 12:26:19 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Michal Simek <monstr@monstr.eu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       torvalds@linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       lkml <linux-arch@vger.kernel.org>, microblaze-uclinux@itee.uq.edu.au,
       Andrew Morton <akpm@linux-foundation.org>,
       John Williams <john.williams@petalogix.com>,
       John Linn <John.Linn@xilinx.com>,
       Stephen Neuendorffer <stephenn@xilinx.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Arnd Bergmann <arnd@arndb.de>,
       Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [GIT PULL] Microblaze initial pack
References: <49CC8A41.4060503@monstr.eu> <20090327103032.GA12485@elte.hu> <20090327104045.GA11518@elte.hu>
In-Reply-To: <20090327104045.GA11518@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> I have noticed one relatively big (but easily fixable) commit 
>> structure problem in this tree.
>>
>> All of the commits have these tags:
>>
>>     Reviewed-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
>>     Acked-by: John Linn <john.linn@xilinx.com>
>>     Acked-by: John Williams<john.williams@petalogix.com>
>>     
>
> I forgot to mention that in any case _your_ signoff as the submitter 
> of this tree should be in all commits as well.
>
> So for example this (sample) chain would be fine:
>
>      Reviewed-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
>      Acked-by: John Linn <john.linn@xilinx.com>
>      Acked-by: John Williams<john.williams@petalogix.com>
>      Signed-off-by: Michal Simek <monstr@monstr.eu>
>
> It's not enough to be listed as the author in the commit. (In any 
> case please see Documentation/SubmittingPatches and the DCO 1.1.)
>   
I add my name there too.

> Also, a minor stylistic detail, please fix this:
>
>      John Williams<john.williams@petalogix.com>
>
> to:
>
>      John Williams <john.williams@petalogix.com>
>   
I fixed that space problem.

Thanks,
Michal
> Thanks,
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

