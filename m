Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYGWMtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYGWMtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYGWMtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:49:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48587 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYGWMtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:49:42 -0400
Date: Wed, 23 Jul 2008 14:49:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [git pull] x86: declaration fixes - ver3
Message-ID: <20080723124918.GA7297@elte.hu>
References: <1216815947.11897.2.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1216815947.11897.2.camel@jaswinder.satnam>
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


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> ﻿Hello Ingo,
>  
> Please pull these patches for x86-tip.
> 
> The following changes since commit 1e84911c6c37fd1080ef07039e19c346628b31db:
>   Jaswinder Singh (1):
>         x86: mtrr/main.c declare range_state as static
> 
> are available in the git repository at:
> 
>   git://git.infradead.org/users/jaswinder/linux-2.6-tip.git x86/prototypes-for-tip
> 
> Jaswinder Singh (8):
>       x86: apic_XX.c declare functions before they get used
>       x86: vm86_32.c declare functions before they get used
>       x86: mm/init_XX.c declare functions before they get used
>       x86: mm/fault.c declare do_page_fault before they get used
>       x86: mm/ioremap.c declare early_ioremap_debug and early_ioremap_nested as static
>       x86: mm/pageattr.c declare arch_report_meminfo before they get used
>       x86: mm/pgtable_32.c declare set_pmd_pfn before they get used
>       x86: mach-default/setup.c declare no_broadcast before they get used

pulled, thanks Jaswinder.

	Ingo
