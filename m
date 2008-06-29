Return-Path: <linux-kernel-owner+w=401wt.eu-S1759780AbYF2Jty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780AbYF2Jty (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 05:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbYF2Jtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 05:49:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42694 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbYF2JtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 05:49:14 -0400
Date: Sun, 29 Jun 2008 11:49:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: use disable_apic in 32bit
Message-ID: <20080629094903.GB3001@elte.hu>
References: <200806290006.37474.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806290006.37474.yhlu.kernel@gmail.com>
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

> change the enable_local_apic to static force_enable_local_apic for 
> 32bit

>  3 files changed, 8 insertions(+), 15 deletions(-)

applied, thanks.

	Ingo
