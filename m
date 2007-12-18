Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbXLRNDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbXLRNDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 08:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbXLRNC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 08:02:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbXLRNC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 08:02:56 -0500
Date: Tue, 18 Dec 2007 14:01:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] arch/x86/: Spelling fixes
Message-ID: <20071218130114.GA2447@elte.hu>
References: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
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


* Joe Perches <joe@perches.com> wrote:

> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/x86/kernel/apic_32.c    |    2 +-
>  arch/x86/kernel/mpparse_32.c |    2 +-
>  arch/x86/kernel/vm86_32.c    |    2 +-
>  arch/x86/mm/srat_64.c        |    2 +-

thanks, applied.

	Ingo
