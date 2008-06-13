Return-Path: <linux-kernel-owner+w=401wt.eu-S1760503AbYFMNyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503AbYFMNyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 09:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYFMNyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 09:54:08 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:57150 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbYFMNyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 09:54:07 -0400
Date: Fri, 13 Jun 2008 16:52:55 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080613135255.GB21341@cs181133002.pp.htv.fi>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.BVD.E3vSIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dCRO4tbfLzK.A.BVD.E3vSIB@albercik>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2008 at 10:42:57PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10815
> Subject		: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
> Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
> Date		: 2008-05-27 09:23 (12 days old)
> References	: http://lkml.org/lkml/2008/5/27/9
> Handled-By	: Oleg Nesterov <oleg@tv-sign.ru>
> 		  Linus Torvalds <torvalds@linux-foundation.org>
> 		  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Patch		: http://lkml.org/lkml/2008/5/28/16

What happened with this issue?

It is currently listed as 2.6.26-rc regression.
Is this correct?

And if this patch is required it might not be a good idea to allow the 
use to disable the new code.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

