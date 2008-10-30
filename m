Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYJ3Kop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYJ3Kop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 06:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYJ3Koh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 06:44:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60048 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbYJ3Kog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 06:44:36 -0400
Date: Thu, 30 Oct 2008 11:44:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: signal: cosmetic unification of
	signr_convert()
Message-ID: <20081030104422.GE3569@elte.hu>
References: <49091168.1070609@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49091168.1070609@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Make signr_convert() same.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/kernel/signal_32.c |    2 ++
>  arch/x86/kernel/signal_64.c |    6 ++++++
>  2 files changed, 8 insertions(+), 0 deletions(-)

applied your patches to tip/x86/signal:

 5791775: x86: signal: cosmetic unification of NR_restart_syscall
 cabf503: x86: signal: cosmetic unification of macros for setup_rt_frame()
 96bf84b: x86: signal: cosmetic unification of signr_convert()

thanks!

	Ingo
