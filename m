Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYEDIlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYEDIlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 04:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbYEDIk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 04:40:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37797 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbYEDIk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 04:40:58 -0400
Date: Sun, 4 May 2008 10:40:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanup print out for mptable
Message-ID: <20080504084041.GA21859@elte.hu>
References: <200805031918.02245.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805031918.02245.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> wil get
> MPTABLE: OEM ID: SUN
> MPTABLE: Product ID: 4600 M2
> MPTABLE: APIC at: 0x
> 
> instead of in one line with <6> and double Product ID...

applied, thanks.

	Ingo
