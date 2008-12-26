Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYLZJoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYLZJoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYLZJoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:44:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52194 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbYLZJoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:44:00 -0500
Date: Fri, 26 Dec 2008 10:43:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparseirq: remove duplicated arch_early_irq_init()
Message-ID: <20081226094346.GO27747@elte.hu>
References: <4951905C.6010802@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4951905C.6010802@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: clean up
> 
> already have one weak copy in init/main.c
> 
> Signed-off-by: Yinghai <yinghai@kernel.org>
> 
> ---
>  kernel/irq/handle.c |    4 ----
>  1 file changed, 4 deletions(-)

applied to tip/irq/sparseirq, thanks Yinghai!

	Ingo
