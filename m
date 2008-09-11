Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784AbYIKHJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbYIKHJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 03:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYIKHI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 03:08:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36436 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbYIKHIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 03:08:55 -0400
Date: Thu, 11 Sep 2008 09:08:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: io-apic - get rid of __DO_ACTION macro
Message-ID: <20080911070839.GE27877@elte.hu>
References: <20080909184615.GA7303@lenovo> <86802c440809091313l6b3e1f48x6e3b5cd0b948ccf9@mail.gmail.com> <aa79d98a0809092302g60967a60sd0609044a6d6a137@mail.gmail.com> <86802c440809092322w363cc9dbt5eb172d5c80a6adc@mail.gmail.com> <20080910093105.GA5259@elte.hu> <86802c440809101030q758d2f92v470727c88654d91d@mail.gmail.com> <20080910181950.GC8067@lenovo> <86802c440809101140w55602b9as94b09b4d7c3ea661@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809101140w55602b9as94b09b4d7c3ea661@mail.gmail.com>
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

> > Yinghai, Ingo, what about this one?

> looks good.

applied to tip/irq/sparseirq - thanks guys!

	Ingo
