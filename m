Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbYFSMMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbYFSMMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbYFSMMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:12:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37882 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbYFSMMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:12:40 -0400
Date: Thu, 19 Jun 2008 14:12:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove unused file after numaq etc depends on
	genericarch
Message-ID: <20080619121224.GC7640@elte.hu>
References: <200806171539.01555.yhlu.kernel@gmail.com> <200806181154.37444.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806181154.37444.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> we don't need those mach_mpsech.h now.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  include/asm-x86/mach-bigsmp/mach_mpspec.h |    8 --------
>  include/asm-x86/mach-es7000/mach_mpspec.h |    8 --------
>  include/asm-x86/mach-numaq/mach_mpspec.h  |    8 --------
>  include/asm-x86/mach-summit/mach_mpspec.h |    9 ---------
>  4 files changed, 33 deletions(-)

applied to tip/x86/mpparse, thanks.

nice cleanup!

	Ingo
