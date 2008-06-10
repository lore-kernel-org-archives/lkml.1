Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbYFJKfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbYFJKfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYFJKf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:35:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37255 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbYFJKf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:35:28 -0400
Date: Tue, 10 Jun 2008 12:35:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: tglx <tglx@linutronix.de>, hpa <hpa@zytor.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: coding style fixes to
	arch/x86/kernel/sys_i386_32.c
Message-ID: <20080610103518.GJ19136@elte.hu>
References: <20080607143442.0d67012b@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080607143442.0d67012b@paolo-desktop>
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


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> Before:
> total: 16 errors, 25 warnings, 246 lines checked
> 
> After:
> total: 0 errors, 7 warnings, 246 lines checked
> 
> Compile tested.
> 
> paolo@paolo-desktop:/tmp$ size sys*
>    text    data     bss     dec     hex filename
>    1209       0       0    1209     4b9 sys_i386_32.o.after
>    1209       0       0    1209     4b9 sys_i386_32.o.before
> 
> paolo@paolo-desktop:/tmp$ md5sum sys*
> 6144f6d6ce7342c3e192681a1ccaa1c1  sys_i386_32.o.after
> 6144f6d6ce7342c3e192681a1ccaa1c1  sys_i386_32.o.before

applied to tip/x86/cleanups, thanks.

	Ingo
