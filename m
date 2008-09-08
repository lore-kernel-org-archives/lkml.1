Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765AbYIHNqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbYIHNqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYIHNqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:46:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46292 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbYIHNqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:46:15 -0400
Date: Mon, 8 Sep 2008 15:45:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] x86: lapic address print out like io apic addr
Message-ID: <20080908134557.GC11993@elte.hu>
References: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com> <1220835538-18280-8-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220835538-18280-8-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> ---
>  arch/x86/kernel/apic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied to tip/irq/sparseirq - thanks Yinghai!

	Ingo
