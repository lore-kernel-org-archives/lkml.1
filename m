Return-Path: <linux-kernel-owner+w=401wt.eu-S934660AbXK3LlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934660AbXK3LlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 06:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756661AbXK3Lk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 06:40:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47435 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493AbXK3Lk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 06:40:58 -0500
Date: Fri, 30 Nov 2007 12:40:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 05/11] x86 ptrace getreg/putreg merge
Message-ID: <20071130114038.GA21520@elte.hu>
References: <20071129115711.9FC8526F8E7@magilla.localdomain> <20071129115954.12D3126F8E7@magilla.localdomain> <20071129092715.2674bfe1.akpm@linux-foundation.org> <20071129222842.9613826F8E7@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129222842.9613826F8E7@magilla.localdomain>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> > This didn't need to be implemented as a macro hence it shouldn't have been.
> 
> Ok.
> 
> 
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index b3433e1..0000000 100644  
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c

i have added this to x86.git.

	Ingo
