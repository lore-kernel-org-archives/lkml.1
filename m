Return-Path: <linux-kernel-owner+w=401wt.eu-S1757666AbZCZQJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666AbZCZQJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 12:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZCZQJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 12:09:24 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:29509 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751388AbZCZQJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:09:23 -0400
X-BigFish: VPS-40(zz1432R62a3L98dR936eQ4015M1805Mzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KH4FIV-03-KUP-01
Date: Thu, 26 Mar 2009 17:08:56 +0100
From: Robert Richter <robert.richter@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [git-pull -tip] x86: unification and cleanup patches 20090326
Message-ID: <20090326160856.GF3226@erda.amd.com>
References: <1238080231.2852.4.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1238080231.2852.4.camel@ht.satnam>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 26 Mar 2009 16:08:57.0530 (UTC) FILETIME=[2B0551A0:01C9AE2D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.03.09 20:40:31, Jaswinder Singh Rajput wrote:
> Individual log and patches are available at:
> http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tip.git;a=shortlog;h=x86/core
> 
> The following changes since commit 29219683c46cb89edf5c58418b5305b14646d030:
>   Ingo Molnar (1):
>         Merge branches 'x86/apic', 'x86/cleanups', 'x86/mm', 'x86/pat', 'x86/setup' and 'x86/signal'; commit 'v2.6.29' into x86/core
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git x86/core
> 
> Jaswinder Singh Rajput (3):
>       x86: unification of cpu/bugs.c
>       x86: cpu/bugs.c cleanup
>       x86: unification of module.c

Jaswinder,

again, please send numbered patches to the list instead of a complete
diff.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

