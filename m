Return-Path: <linux-kernel-owner+w=401wt.eu-S1761159AbYGRRIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761159AbYGRRIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbYGRRHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:07:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46998 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760696AbYGRRHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:07:19 -0400
Date: Fri, 18 Jul 2008 19:07:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too - fix
Message-ID: <20080718170706.GJ6875@elte.hu>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com> <200807111841.55403.yhlu.kernel@gmail.com> <200807132219.35814.yhlu.kernel@gmail.com> <20080715173318.GA18203@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715173318.GA18203@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Yinghai, Looking more closely at this, based on my understanding this 
> might be wrong for VMI. Correct patch should be as follows. Any 
> comments?

applied to tip/x86/x2apic (with some fixups), thanks Suresh.

	Ingo
