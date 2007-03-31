Return-Path: <linux-kernel-owner+w=401wt.eu-S965030AbXCaDQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965030AbXCaDQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 23:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965045AbXCaDQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 23:16:55 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39066 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964863AbXCaDQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 23:16:52 -0400
Date: Sat, 31 Mar 2007 05:16:50 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Len Brown <len.brown@intel.com>,
       linux-acpi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [3/4] 2.6.21-rc5: known regressions (v2)
Message-ID: <20070331031650.GR14134@stusta.de>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070330213220.GO14134@stusta.de> <b6a2187b0703301952s6042fbfdu2e15e0f868a958f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b6a2187b0703301952s6042fbfdu2e15e0f868a958f4@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 10:52:59AM +0800, Jeff Chua wrote:
> On 3/31/07, Adrian Bunk <bunk@stusta.de> wrote:
> 
> >Subject    : ThinkPad doesn't resume from suspend to RAM
> >References : http://lkml.org/lkml/2007/2/27/80
> >             http://lkml.org/lkml/2007/2/28/348
> >Submitter  : Jens Axboe <jens.axboe@oracle.com>
> >             Jeff Chua <jeff.chua.linux@gmail.com>
> >Status     : unknown
> 
> Fixed with CONFIG_NO_HZ unset and patch from Maxim
> (http://lkml.org/lkml/2007/3/29/108).

Thanks for this information.

Jens, does suspend to RAM also work for you with the latest -git?

> Thanks,
> Jeff,

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

