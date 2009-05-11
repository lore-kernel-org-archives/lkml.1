Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbZEKNQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbZEKNQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZEKNQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:16:12 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:44684
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753816AbZEKNQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:16:10 -0400
X-BigFish: VPS-39(zz1432R62a3L98dR936eQ4015L1805Mzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KJHE6D-04-69N-01
Date: Mon, 11 May 2009 15:15:49 +0200
From: Robert Richter <robert.richter@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter, x86: remove
	X86_FEATURE_ARCH_PERFMON flag for AMD cpus
Message-ID: <20090511131549.GB10722@erda.amd.com>
References: <1241002046-8832-2-git-send-email-robert.richter@amd.com> <tip-da1a776be1ac7f78bb30ececbec4c1383163b079@git.kernel.org> <1241931753.4796.15.camel@localhost.localdomain> <1241934795.4796.55.camel@localhost.localdomain> <20090510063047.GD30778@elte.hu> <1242044024.10115.3.camel@localhost.localdomain> <20090511123935.GA10722@erda.amd.com> <1242047232.3301.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1242047232.3301.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 May 2009 13:15:51.0022 (UTC) FILETIME=[9B2E78E0:01C9D23A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.05.09 18:37:12, Jaswinder Singh Rajput wrote:
> > which branch is this patch against? It is not tip/perfcounters/core
> > nor tip/master.
> > 
> 
> This patch was based on
> http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tip.git;a=summary
> (git tree takes some time for update)
> 
> These patches are still for review and I will release these patches in
> one or two days after adding some more patches.

Could you submit the patch relative to a tip tree please?

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

