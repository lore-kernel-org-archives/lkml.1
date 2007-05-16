Return-Path: <linux-kernel-owner+w=401wt.eu-S1763252AbXEPRlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763252AbXEPRlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763098AbXEPRlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:41:17 -0400
Received: from mta13.adelphia.net ([68.168.78.44]:51046 "EHLO
	mta13.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763095AbXEPRlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:41:15 -0400
Message-ID: <464B4235.5030405@acm.org>
Date: Wed, 16 May 2007 12:41:09 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Serial 8250: Handle saving the clear-on-read bits from
 the LSR and MSR
References: <20070504131532.GA12265@localdomain> <200705041304.02618.gene.heskett@gmail.com> <463B7FBC.3090907@acm.org> <200705061258.25351.gene.heskett@gmail.com> <20070506181422.GB21158@flint.arm.linux.org.uk>
In-Reply-To: <20070506181422.GB21158@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Sun, May 06, 2007 at 12:58:25PM -0400, Gene Heskett wrote:
>   
>> [long message snipped]
>>
>> Thanks for your patience Corey.
>>     
>
> So, in one sentence or preferably one word, did Corey's patch cause a
> regression?
>   
>From what Gene said, I think the final outcome is that this patch didn't
seem to make any difference. It looks to me that the problems were
elsewhere.

So what's the state of this patch?

Thanks,

-corey

