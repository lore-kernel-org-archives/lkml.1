Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZCCLrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZCCLrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZCCLrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:47:46 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:58911 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751335AbZCCLrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:47:45 -0500
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Mar 2009 06:47:45 EST
X-BigFish: VPS-33(z21eWz1432R62a3L98dR936eQ1805Mzzzz3198u327anz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KFXHDU-04-NRR-01
Date: Tue, 3 Mar 2009 12:32:18 +0100
From: Robert Richter <robert.richter@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>, Tim Blechmann <tim@klingt.org>
Subject: Re: [Bug #12395] 2.6.28-rc9: oprofile regression
Message-ID: <20090303113218.GE10085@erda.amd.com>
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera> <LLno3yT_fnC.A.Lh.4zzoJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <LLno3yT_fnC.A.Lh.4zzoJB@chimera>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Mar 2009 11:32:18.0860 (UTC) FILETIME=[B5F106C0:01C99BF3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix upstream in tip/x86/urgent:

780eef9492b16a1543a3b2ae9f9526a735fc9856

-Robert

On 23.02.09 23:03:00, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12395
> Subject		: 2.6.28-rc9: oprofile regression
> Submitter	: Tim Blechmann <tim@klingt.org>
> Date		: 2008-12-21 14:23 (65 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b99170288421c79f0c2efa8b33e26e65f4bb7fb8
> References	: http://marc.info/?l=linux-kernel&m=122986946614791&w=4
> Handled-By	: Andi Kleen <ak@linux.intel.com>
> 
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

