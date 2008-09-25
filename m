Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYIYImq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYIYImq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 04:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYIYImg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 04:42:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35230 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbYIYImf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 04:42:35 -0400
Date: Thu, 25 Sep 2008 10:42:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
Message-ID: <20080925084212.GE4519@elte.hu>
References: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> v2: fix hpet compiling
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> ---
>  arch/x86/kernel/hpet.c    |    3 +++
>  arch/x86/kernel/io_apic.c |    7 +++++++
>  2 files changed, 10 insertions(+), 0 deletions(-)

applied to tip/irq/sparseirq, thanks Yinghai.

	Ingo
