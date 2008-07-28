Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYG1ODm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYG1ODm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbYG1ODU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:03:20 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:49700 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbYG1ODT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:03:19 -0400
X-BigFish: VPS-19(zz1432R98dR936eQ62a3L148cM1805Mzz10d3izzz32i6bh87il43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4PZ13-02-L3Y-01
Date: Mon, 28 Jul 2008 16:02:57 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Barry Kasindorf <barry.kasindorf@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, Jason Yeh <jason.yeh@amd.com>
Subject: Re: [PATCH 0/24] oprofile: Add IBS support for AMD CPUs
Message-ID: <20080728140257.GO15356@erda.amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com> <20080726095221.GB25890@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080726095221.GB25890@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 28 Jul 2008 14:03:07.0270 (UTC) FILETIME=[A9295260:01C8F0BA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.07.08 11:52:21, Ingo Molnar wrote:
> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > Patches #1-3 are not directly related to IBS.
> > Patch #4 adds generic support of model specific initialization.
> > Patches #10, #11 add the core implementation of IBS.
> > Patches #12-24 contain code improvements and small fixes.
> 
> cool stuff! I've created the tip/oprofile topic branch for the patches 
> from you, Barry and Jason and have applied all the current patches (and 
> followup fixes) to it. Below are the access coordinates and the log 
> summary.
> 
> It's not yet integrated into tip/master - will do some testing first. 
> I'll send review feedback separately as well, on a per patch basis.

Ingo,

thanks for adding the patches to tip/oprofile. I will send you more
patches that reflect the comments you made.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

