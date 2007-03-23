Return-Path: <linux-kernel-owner+w=401wt.eu-S933940AbXCWTlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940AbXCWTlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934134AbXCWTln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:41:43 -0400
Received: from www.osadl.org ([213.239.205.134]:42452 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933940AbXCWTlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:41:42 -0400
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Soeren Sonnenburg <kernel@nn7.de>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <htejun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20070323185028.GR752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185028.GR752@stusta.de>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 20:49:03 +0100
Message-Id: <1174679344.10840.334.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 19:50 +0100, Adrian Bunk wrote:
> This email lists some known regressions in Linus' tree compared to 2.6.20.
> 
> If you find your name in the Cc header, you are either submitter of one
> of the bugs, maintainer of an affectected subsystem or driver, a patch
> of you caused a breakage or I'm considering you in any other way
> possibly involved with one or more of these issues.
> 
> Due to the huge amount of recipients, please trim the Cc when answering.
> 
> 
> Subject    : system doesn't come out of suspend  (CONFIG_NO_HZ)
> References : http://lkml.org/lkml/2007/2/22/391
> Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
>              Soeren Sonnenburg <kernel@nn7.de>
> Handled-By : Thomas Gleixner <tglx@linutronix.de>
>              Ingo Molnar <mingo@elte.hu>
>              Tejun Heo <htejun@gmail.com>
>              Rafael J. Wysocki <rjw@sisk.pl>
> Status     : problem is being debugged
> 
> 
> Subject    : first disk access after resume takes several minutes
>              ('date' does not advance after resume from RAM, CONFIG_NO_HZ=n)
> References : http://lkml.org/lkml/2007/3/8/117
> Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
> Handled-By : Thomas Gleixner <tglx@linutronix.de>
>              Ingo Molnar <mingo@elte.hu>
> Status     : problem is being debugged

I lost track of Michaels various nested problems.

Michael can you please give a summary on _all_ entries in the
regressions list against Linus latest ?

Thanks,

	tglx


