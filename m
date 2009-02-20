Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbZBTLIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbZBTLIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 06:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbZBTLIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 06:08:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57063 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZBTLIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 06:08:10 -0500
Date: Fri, 20 Feb 2009 12:08:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: use symbolic constants for MSR_IA32_MISC_ENABLE
	bits
Message-ID: <20090220110804.GI28581@elte.hu>
References: <20090220105638.GA22786@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220105638.GA22786@damson.getinternet.no>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> >From d465c8c135e64c9aabfbf83175fb90b41912b1da Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Fri, 20 Feb 2009 11:49:34 +0100
> Subject: [PATCH] x86: use symbolic constants for MSR_IA32_MISC_ENABLE bits
> 
> Impact: Cleanup. No functional changes.
> 
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  arch/x86/kernel/cpu/cpufreq/e_powersaver.c       |    6 +++---
>  arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |    6 +++---
>  arch/x86/kernel/cpu/intel.c                      |    4 ++--
>  arch/x86/kernel/cpu/mcheck/mce_intel_64.c        |    6 +++---
>  arch/x86/kernel/cpu/mcheck/p4.c                  |    4 ++--
>  5 files changed, 13 insertions(+), 13 deletions(-)

Applied to tip:x86/cleanups, thanks Vegard!

	Ingo
