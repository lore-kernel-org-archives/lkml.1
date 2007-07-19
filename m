Return-Path: <linux-kernel-owner+w=401wt.eu-S936496AbXGSAFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936496AbXGSAFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760876AbXGSAFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:05:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33898 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761650AbXGSAFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:05:22 -0400
Message-ID: <469EAABD.4010504@garzik.org>
Date: Wed, 18 Jul 2007 20:05:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net, benh@kernel.crashing.org
Subject: Re: [git patches] two warning fixes
References: <20070718235504.GA9601@havoc.gtf.org> <200707190159.22654.ak@suse.de>
In-Reply-To: <200707190159.22654.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Thursday 19 July 2007 01:55:04 Jeff Garzik wrote:
>> Please pull from 'warnings' branch of
>> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git warnings
>>
>> to receive the following updates:
>>
>>  drivers/video/aty/radeon_base.c |   23 ++++++++++++++++++-----
>>  include/asm-x86_64/tlbflush.h   |    6 +++++-
>>  2 files changed, 23 insertions(+), 6 deletions(-)
>>
>> Jeff Garzik (2):
>>       drivers/video/aty/radeon_base: fix radeonfb_pci_register() err handling
>>       [X86-64] make flush_tlb_kernel_range() a static inline function
> 
> I already got that patch queued. Why don't you send them through the maintainers?

Because in both cases the maintainers never responded to me, indicating 
they were queued?

Also, you haven't pushed anything upstream during this merge window 
AFAICS, and I didn't want to miss it because you were being slow.

	Jeff



