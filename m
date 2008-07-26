Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbYGZPEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbYGZPEe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 11:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYGZPE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 11:04:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47366 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbYGZPE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:04:26 -0400
Date: Sat, 26 Jul 2008 17:04:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [git pull] x86: patches for tip/x86/prototypes
Message-ID: <20080726150412.GA10036@elte.hu>
References: <1216968669.18082.6.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1216968669.18082.6.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0037]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> ﻿Hello Ingo,
> 
> Please pull these patches for tip/x86/prototypes.
> 
> I have also verify that these are merge-able with tip/master and working.
> 
> ﻿The following changes since commit 71e3b818431957371c7f69fa1c576d4a403c1478:
>   Jaswinder Singh (1):
>         x86: mach-default/setup.c declare no_broadcast before they get used
> 
> are available in the git repository at:
> 
>   git://git.infradead.org/users/jaswinder/linux-2.6-tip.git x86/prototypes-for-tip
> 
> Jaswinder Singh (6):
>       x86_64: Declare new_utsname in asm-x86/syscalls.h
>       X86_32: declare pt_regs_access as unsigned long
>       X86_SMP: smp.c declare functions before they get used
>       X86_SMP: smpboot.c declare idle_thread_array and smp_b_stepping as static
>       X86_SMP: ipi.c declare functions before they get used
>       X86_SMP: tlb_XX.c declare smp_invalidate_interrupt before they get used

pulled into tip/x86/prototypes - thanks Jaswinder.

	Ingo
