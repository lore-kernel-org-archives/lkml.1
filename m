Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbYFPHyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbYFPHyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYFPHyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:54:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46599 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbYFPHyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:54:15 -0400
Date: Mon, 16 Jun 2008 09:53:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: using dstapic in mp_config_acpi_legacy_irqs
Message-ID: <20080616075350.GA25632@elte.hu>
References: <200806151819.47236.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806151819.47236.yhlu.kernel@gmail.com>
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

> so don't get that same value multiple times.
> 
> also make mp_config_acpi_legacy_irqs more readable by moving some 
> assignment together.

applied to tip/x86/mpparse - thanks Yinghai.

	Ingo
