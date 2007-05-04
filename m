Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbXEDMG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbXEDMG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 08:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbXEDMG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 08:06:26 -0400
Received: from rex.snapgear.com ([203.143.235.140]:34626 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752869AbXEDMGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 08:06:24 -0400
Message-ID: <463B21B7.6090505@snapgear.com>
Date: Fri, 04 May 2007 22:06:15 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: use generic irq framework
References: <200705040013.l440DGjB011704@goober> <20070504110655.GA2936@infradead.org>
In-Reply-To: <20070504110655.GA2936@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Christoph,

Christoph Hellwig wrote:
>> --- linux-2.6.21/arch/m68knommu/kernel/irq.c	1970-01-01 10:00:00.000000000 +1000
>> +++ linux-2.6.21-gt/arch/m68knommu/kernel/irq.c	2007-05-04 00:20:44.000000000 +1000
>> @@ -0,0 +1,82 @@
>> +/*
>> + * arch/m68knommu/kernel/irq.c
> 
> No need for top of file filename comments, they don't provide anything
> but easily get out of sync.

Ok, I'll take that.


> Except for that little nitpick the patch looks very good to me,
> thanks a lot for doing the conversion.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
