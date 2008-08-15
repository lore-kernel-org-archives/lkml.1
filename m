Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbYHOOyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbYHOOyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961AbYHOOyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:54:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42322 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbYHOOyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:54:12 -0400
Date: Fri, 15 Aug 2008 16:53:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: hpa <hpa@zytor.com>, tglx <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Coding style fixes
Message-ID: <20080815145359.GM12954@elte.hu>
References: <20080802212131.22e89531@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080802212131.22e89531@paolo-desktop>
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

> Hi all,
> a new round of coding style fixes.
> 
> 
> Paolo Ciarrocchi (5):
>   x86: Coding style fixes to arch/x86/boot/compressed/misc.c
>   x86: Coding style fixes to arch/x86/kernel/bios_uv.c
>   x86: Coding style fixes to arch/x86/lib/strstr_32.c
>   x86: Coding style fixes to arch/x86/lib/string_32.c
>   x86: Coding style fixes to arch/x86/kernel/paravirt_patch_32.c
> 
>  arch/x86/boot/compressed/misc.c     |   10 +++++---
>  arch/x86/kernel/bios_uv.c           |   20 ++++++++++++----
>  arch/x86/kernel/paravirt_patch_32.c |    2 +-
>  arch/x86/lib/string_32.c            |   42 +++++++++++++++++-----------------
>  arch/x86/lib/strstr_32.c            |    6 ++--
>  5 files changed, 46 insertions(+), 34 deletions(-)

thanks, applied them to tip/x86/cleanups. (Note: i changed the second 
one) Thanks Paolo,

	Ingo
