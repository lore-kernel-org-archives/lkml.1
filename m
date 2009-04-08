Return-Path: <linux-kernel-owner+w=401wt.eu-S1762370AbZDHGIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762370AbZDHGIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760786AbZDHGIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:08:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:30472 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760323AbZDHGIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:08:02 -0400
Message-ID: <49DC3F3F.4000009@petalogix.com>
Date: Wed, 08 Apr 2009 08:07:59 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       John Williams <john.williams@petalogix.com>,
       John Linn <John.Linn@xilinx.com>
Subject: Re: Linux 2.6.30-rc1
References: <alpine.LFD.2.00.0904071700170.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904071700170.4583@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
> Other? Arch updates - amainly rm, powerpc, sh and x86. Firmware updates. 
> And lots and lots of driver updates, including some more core 
> suspend/resume changes (hopefully the last really fundamental ones). 
>
>   
I would like to ask again if you can pull new Microblaze arch to your
tree. All patches go
to arch/microblaze folder (+ one change in serial Kconfig). Ingo
reviewed all patches.
Ingo told me that you are just busy and you added Microblaze at the end
you huge merge list. I was OK with it
and wait and I see that Microblaze wasn't there.
My request is in LKML from 28.3.2008. We sent you some private email but
we don't have any your response.
Thomas Gleixner wrote you private email too. Do you have any response?
I am going to send you my request in special email again.

Is that anything wrong with Microblaze or don't you want to add new arch?

Thanks,
Michal


> Go out and try it,
>
> 		Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

