Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbYGRRHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbYGRRHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757065AbYGRRG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:06:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44184 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757025AbYGRRG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:06:56 -0400
Date: Fri, 18 Jul 2008 19:06:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too - fix
Message-ID: <20080718170639.GI6875@elte.hu>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com> <200807111841.55403.yhlu.kernel@gmail.com> <200807132219.35814.yhlu.kernel@gmail.com> <20080714071207.GB17077@elte.hu> <20080714164913.GK1678@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080714164913.GK1678@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Ingo, before you try for the third attempt ;) we need one more lguest 
> apic_ops fix. Patch appended. Thanks.
> 
> ---
> [patch] x86: apic_ops for lguest
> 
> apic_ops for lguest.

applied to tip/x86/x2apic, thanks Suresh.

	Ingo
