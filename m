Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbYGZOes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbYGZOes (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 10:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbYGZOeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 10:34:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52996 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684AbYGZOeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 10:34:20 -0400
Date: Sat, 26 Jul 2008 16:34:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: arch/x86/kernel/visws_quirks.c: Removed duplicated #include
Message-ID: <20080726143405.GJ4401@elte.hu>
References: <20080725225407.913A.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725225407.913A.WEIYI.HUANG@gmail.com>
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


* Huang Weiyi <weiyi.huang@gmail.com> wrote:

> Removed duplicated #include in arch/x86/kernel/visws_quirks.c.
>       asm/apic.h
>       asm/arch_hooks.h
>       asm/io.h
>       asm/visws/cobalt.h
>       asm/visws/lithium.h
>       asm/visws/piix4.h
>       linux/init.h
>       linux/interrupt.h
>       linux/smp.h
> 
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

applied to tip/x86/cleanups - thanks.

	Ingo
