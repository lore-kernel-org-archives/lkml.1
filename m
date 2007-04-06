Return-Path: <linux-kernel-owner+w=401wt.eu-S933133AbXDFWau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133AbXDFWau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933142AbXDFWau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:30:50 -0400
Received: from mail.tmr.com ([64.65.253.246]:59342 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933133AbXDFWat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:30:49 -0400
Message-ID: <4616CA22.7040005@tmr.com>
Date: Fri, 06 Apr 2007 18:30:58 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       davej@codemonkey.org.uk, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: [2.6 patch] the overdue removal of X86_SPEEDSTEP_CENTRINO_ACPI
References: <20070220000641.GG13958@stusta.de>
In-Reply-To: <20070220000641.GG13958@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch contains the overdue removal of X86_SPEEDSTEP_CENTRINO_ACPI.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
It would be really nice, when removing features used on computers which 
are only a few years old, if you noted what replaces this functionality. 
Yes, people can take 10-15 minutes to find and read previous discussion, 
but one or two sentences who generate less concern and noise on the list.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
