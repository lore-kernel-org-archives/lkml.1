Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYKUHzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYKUHzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 02:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYKUHzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 02:55:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47431 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbYKUHzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 02:55:10 -0500
Date: Fri, 21 Nov 2008 08:54:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: signal: rename COPY_SEG_STRICT to COPY_SEG_CPL3
Message-ID: <20081121075454.GB16242@elte.hu>
References: <49261DB1.7070009@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49261DB1.7070009@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Impact: cleanup
> 
> Rename macro COPY_SEG_STRICT to COPY_SEG_CPL3.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/kernel/signal_32.c |    8 ++++----
>  arch/x86/kernel/signal_64.c |    8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)

applied to tip/x86/signal, thanks.

I thought i already did it based on hpa's suggestion in the previous 
discussion but apparently i forgot about it :-/

	Ingo
