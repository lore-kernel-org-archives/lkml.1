Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYJEJOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYJEJOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 05:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYJEJOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 05:14:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60883 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbYJEJOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 05:14:02 -0400
Date: Sun, 5 Oct 2008 11:13:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: sparse_irq: fix typo in debug print out
Message-ID: <20081005091344.GB16819@elte.hu>
References: <1223160735-4782-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223160735-4782-1-git-send-email-yhlu.kernel@gmail.com>
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

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> ---
>  arch/x86/kernel/io_apic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to tip/irq/sparseirq, thanks Yinghai!

	Ingo
