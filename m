Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbZHUBmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbZHUBmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 21:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZHUBmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 21:42:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48559 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZHUBmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 21:42:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A8DFB3F.40309@jp.fujitsu.com>
Date: Fri, 21 Aug 2009 10:41:19 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v6 for 2.6.32] x86: MCE: Re-implement MCE log ring buffer
 as per-CPU ring buffer
References: <1250736679.5337.540.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1250736679.5337.540.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> Re-implement MCE log ring buffer as per-CPU ring buffer for better
> scalability.
> 
(snip)
> ChangeLog:
> 
> v6:
> 
> - Rebased on latest x86-tip.git/x86/mce + x86/tip

Does this mean your patch is based on a local branch you merged?
Why not on tip/x86/mce alone as usual?
What branch are you requesting this patch to be applied to?

Thanks,
H.Seto

