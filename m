Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbYKCIS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbYKCIS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 03:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbYKCISt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 03:18:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35112 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbYKCISs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 03:18:48 -0500
Date: Mon, 3 Nov 2008 09:18:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Aristeu Rozanski <aris@redhat.com>
Subject: Re: [PATCH] x86: nmi - nmi_watchdog boot param docs cleanup
Message-ID: <20081103081820.GC28771@elte.hu>
References: <20081101150651.GA8106@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081101150651.GA8106@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> 1) nmi_watchdog boot parameter is common to 32/64 bit modes. So
> move it from Documentation/x86/x86_64/boot-options.txt to
> Documentation/kernel-parameters.txt and integrate with.
> 
> 2) Also fix [panic] keyword placement -- it ought to be at first
> position otherwise it will not be recognized.
> 
> 3) Document lapoc and ioapic keywords.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

applied to tip/x86/nmi-watchdog, thanks Cyrill!

	Ingo
