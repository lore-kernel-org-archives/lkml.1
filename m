Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbYFJKoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbYFJKoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYFJKoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:44:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49490 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbYFJKoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:44:16 -0400
Date: Tue, 10 Jun 2008 12:43:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: hpa <hpa@zytor.com>, tglx <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: coding style fixes to arch/x86/kernel/io_apic_32.c
Message-ID: <20080610104357.GO19136@elte.hu>
References: <20080608130718.5d36e25b@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608130718.5d36e25b@paolo-desktop>
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


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> Before:
> total: 91 errors, 73 warnings, 2850 lines checked
> 
> After:
> total: 1 errors, 47 warnings, 2848 lines checked

applied the largest portion of this to tip/x86/apic, another bit of it 
to tip/x86/mpparse. (so it's two commits - it's better to spread 
cleanups to their originating topic branches.)

	Ingo
