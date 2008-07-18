Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbYGRLOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbYGRLOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYGRLOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:14:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38412 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbYGRLOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:14:41 -0400
Date: Fri, 18 Jul 2008 13:14:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sebastian Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <srostedt@redhat.co>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: copy + paste typo in asm/ftrace.h
Message-ID: <20080718111431.GZ6875@elte.hu>
References: <20080716213117.GA27890@www.tglx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716213117.GA27890@www.tglx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1380]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sebastian Siewior <bigeasy@linutronix.de> wrote:

> diff --git a/include/asm-x86/ftrace.h b/include/asm-x86/ftrace.h
> index c184441..5c68b32 100644
> --- a/include/asm-x86/ftrace.h
> +++ b/include/asm-x86/ftrace.h
> @@ -1,5 +1,5 @@
>  #ifndef _ASM_X86_FTRACE
> -#define _ASM_SPARC64_FTRACE
> +#define _ASM_X86_FTRACE

applied to tip/x86/urgent, thanks Sebastian.

	Ingo
