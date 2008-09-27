Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbYI0Qck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbYI0Qck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 12:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYI0Qcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 12:32:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33180 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbYI0Qcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 12:32:32 -0400
Date: Sat, 27 Sep 2008 18:32:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Glauber Costa <gcosta@redhat.com>
Subject: Re: [PATCH 1/1] x86: remove extra ifdef
Message-ID: <20080927163212.GC4600@elte.hu>
References: <1222406533-12650-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222406533-12650-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0130]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> also change two func to static
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> ---
>  arch/x86/kernel/irqinit_64.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)

applied to tip/x86/time, thanks Yinghai!

	Ingo
