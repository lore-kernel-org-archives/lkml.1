Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZCZL3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZCZL3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 07:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZCZL26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 07:28:58 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:3619 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752312AbZCZL25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 07:28:57 -0400
X-BigFish: VPS-42(zz1432R62a3L98dR936eQ4015M1805Mzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KH42JM-02-H9L-01
Date: Thu, 26 Mar 2009 12:28:35 +0100
From: Robert Richter <robert.richter@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: cpu/common.c cleanup patches
Message-ID: <20090326112834.GC3226@erda.amd.com>
References: <1237009789.4387.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1237009789.4387.2.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 26 Mar 2009 11:28:36.0213 (UTC) FILETIME=[00BC0A50:01C9AE06]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.03.09 11:19:49, Jaswinder Singh Rajput wrote:
> The following changes since commit 82434c275bbc2f4ab22518004a897126c79f6bf4:
>   Ingo Molnar (1):
>         Merge branch 'irq/genirq'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git master
> 
> Jaswinder Singh Rajput (4):
>       x86: cpu/common.c fix various style problems
>       x86: cpu/common.c declare varibles before they get used
>       x86: cpu/common.c introduced clear_all_debug_regs
>       x86: cpu/common.c fix header files issues

Jaswinder,

please send numbered patches next time instead of a complete diff,
this is much more easier to review.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

