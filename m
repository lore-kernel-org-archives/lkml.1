Return-Path: <linux-kernel-owner+w=401wt.eu-S1750977AbXCVM5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750977AbXCVM5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 08:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbXCVM5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 08:57:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:41262 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXCVM5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 08:57:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tezk8TK1OODTJhHUhsDnf4yN4yX5QLvIB1n3HQxoupVrKJhpDIjD3nKokoAAYW7jWpQPyXncat/7ne67Rlu5G8kiTMyJ2zGSZAKflZDWqepMRHXV1cRO5+sRcqDrFMYjOUqLvE/xZVRlAfhfdmgJltmZq6Zh8PC5bZDuoND/E8g=
Message-ID: <6bffcb0e0703220557h7ff64282qf378623452c07d03@mail.gmail.com>
Date: Thu, 22 Mar 2007 13:57:45 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] setup_boot_APIC_clock() irq-enable fix
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070322093119.GA19394@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0703211338i2aa6f933ube53c6604c78e285@mail.gmail.com>
	 <20070322093119.GA19394@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/03/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
> > Hi Ingo,
>
> > 2.6.21-rc4-rt0
>
> > BUG: at kernel/fork.c:1033 copy_process()
>
> thanks Michal - this is a real bug that affects upstream too. Find the
> fix below - i've test-booted it and it fixes the warning.

Problem is fixed, thanks.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
