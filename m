Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbYGRHot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbYGRHot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 03:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYGRHol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 03:44:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46882 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbYGRHol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 03:44:41 -0400
Date: Fri, 18 Jul 2008 09:44:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/4] x86 step/syscall-trace fixes & cleanups
Message-ID: <20080718074424.GE6875@elte.hu>
References: <20080716230217.3C25715410D@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716230217.3C25715410D@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> Hi!
> 
> I'm posting these four patches for everyone to see on the list, but 
> they can be pulled from GIT as well.

> Roland McGrath (4):
>       x86 ptrace: block-step fix
>       x86 ptrace: unify TIF_SINGLESTEP
>       x86 ptrace: unify syscall tracing
>       x86 ptrace: user-sets-TF nits

pulled into tip/x86/step - thanks Roland!

	Ingo
