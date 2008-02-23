Return-Path: <linux-kernel-owner+w=401wt.eu-S934178AbYBWKpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934178AbYBWKpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 05:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYBWKpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 05:45:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50318 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbYBWKpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 05:45:32 -0500
Date: Sat, 23 Feb 2008 11:45:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: hpa <hpa@zytor.com>, tglx <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/20] Various Coding Style fixes
Message-ID: <20080223104519.GM23833@elte.hu>
References: <20080222230910.2c175eb5@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222230910.2c175eb5@paolo-desktop>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> Various coding style fixes.
> 
> Paolo Ciarrocchi (20):
>       x86: Coding Style fix to arch/x86/boot/pm.c
>       x86: Coding Style fixes to arch/x86/kernel/summit_32.c
>       x86: Coding Style fixes to arch/x86/kernel/cpu/intel.c
>       x86: Coding Style fixes to arch/x86/oprofile/init.c
>       x86: Coding Style fixes to arch/x86/lib/strstr_32.c
>       x86: Coding Style fixes to arch/x86/kernel/mca_32.c
>       x86: Coding Style fixes to arch/x86/kernel/cpu/mtrr/state.c
>       x86: Coding Style fixes to arch/x86/lib/memcpy_32.c
>       x86: Coding Style fixes to arch/x86/kernel/cpu/transmeta.c
>       x86: Coding Style fixes to arch/x86/kernel/cpu/amd.c
>       x86: Coding Style fixes to arch/x86/kernel/vm86_32.c
>       x86: Coding Style fixes to arch/x86/kernel/cpu/mcheck/non-fatal.c
>       x86: Coding Style fixes to arch/x86/kernel/cpu/mcheck/winchip.c
>       x86: Coding Style fixes to arch/x86/kernel/cpu/mcheck/mce_32.c
>       x86: Coding Style fixes to arch/x86/boot/cpucheck.c
>       x86: Coding Style fixes to arch/x86/kernel/cpu/cyrix.c
>       x86: Coding Style fixes to arch/x86/oprofile/nmi_timer_int.c
>       x86: Coding Style fixes to arch/x86/kernel/acpi/sleep.c
>       x86: Coding Style fixes to arch/x86/kernel/msr.c
>       x86: Coding Style fixes to arch/x86/xen/multicalls.c

thanks Paolo, they look good and i've applied all of them.

	Ingo
