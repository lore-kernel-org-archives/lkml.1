Return-Path: <linux-kernel-owner+w=401wt.eu-S933176AbXDFWic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbXDFWic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933217AbXDFWiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:38:23 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44624 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933176AbXDFWiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:38:22 -0400
Date: Sat, 7 Apr 2007 00:38:21 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       davej@codemonkey.org.uk, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: [2.6 patch] the overdue removal of X86_SPEEDSTEP_CENTRINO_ACPI
Message-ID: <20070406223821.GL29169@stusta.de>
References: <20070220000641.GG13958@stusta.de> <4616CA22.7040005@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4616CA22.7040005@tmr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 06:30:58PM -0400, Bill Davidsen wrote:
> Adrian Bunk wrote:
> >This patch contains the overdue removal of X86_SPEEDSTEP_CENTRINO_ACPI.
> >
> >Signed-off-by: Adrian Bunk <bunk@stusta.de>
> >
> It would be really nice, when removing features used on computers which 
> are only a few years old, if you noted what replaces this functionality. 
> Yes, people can take 10-15 minutes to find and read previous discussion, 
> but one or two sentences who generate less concern and noise on the list.

For everyone on linux-kernel, the text my patch removes in 
feature-removal-schedule.txt should be sufficient.

Users already had a printk() stating that it was deprecated.

> Bill Davidsen

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

