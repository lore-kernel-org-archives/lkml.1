Return-Path: <linux-kernel-owner+w=401wt.eu-S1030319AbXCSQPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030319AbXCSQPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030325AbXCSQPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:15:06 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35144 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030319AbXCSQPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:15:03 -0400
Date: Mon, 19 Mar 2007 17:15:04 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [2/6] 2.6.21-rc4: known regressions
Message-ID: <20070319161504.GU752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070318184915.GV752@stusta.de> <20070319090657.3142b8a8.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070319090657.3142b8a8.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 09:06:57AM -0700, Randy Dunlap wrote:
> On Sun, 18 Mar 2007 19:49:15 +0100 Adrian Bunk wrote:
> 
> > This email lists some known regressions in Linus' tree compared to 2.6.20.
> > 
> > If you find your name in the Cc header, you are either submitter of one
> > of the bugs, maintainer of an affectected subsystem or driver, a patch
> > of you caused a breakage or I'm considering you in any other way
> > possibly involved with one or more of these issues.
> > 
> > Due to the huge amount of recipients, please trim the Cc when answering.
> > 
> > 
> > Subject    : x86_64: boot hangs unless CONFIG_PCIEPORTBUS=n and acpi=off
> > References : http://bugzilla.kernel.org/show_bug.cgi?id=8162
> > Submitter  : Randy Dunlap <randy.dunlap@oracle.com>
> > Status     : unknown
> 
> Bug is rejected due to user error.
> This seems to be a netconsole hang, not ACPI.

Thanks for this information.

Is the netconsole hang a regression?

> ~Randy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

