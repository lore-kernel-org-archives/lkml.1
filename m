Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbYIKHIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbYIKHIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 03:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYIKHIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 03:08:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36358 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbYIKHIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 03:08:10 -0400
Date: Thu, 11 Sep 2008 09:07:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: print out apic id with hex format
Message-ID: <20080911070756.GD27877@elte.hu>
References: <1221109006-4315-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221109006-4315-1-git-send-email-yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  arch/x86/kernel/apic.c      |    2 +-
>  arch/x86/kernel/cpu/amd.c   |    2 +-
>  arch/x86/kernel/cpu/intel.c |    2 +-
>  arch/x86/kernel/smpboot.c   |    6 +++---
>  4 files changed, 6 insertions(+), 6 deletions(-)

applied to tip/irq/sparseirq, thanks Yinghai.

	Ingo
