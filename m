Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbYGIFvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbYGIFvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 01:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYGIFvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 01:51:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60462 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYGIFvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 01:51:16 -0400
Date: Wed, 9 Jul 2008 07:51:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Bernhard Walle <bwalle@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let early_reserve_e820 update e820_saved too
Message-ID: <20080709055102.GB9760@elte.hu>
References: <200807031135.37465.yhlu.kernel@gmail.com> <200807031139.00349.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807031139.00349.yhlu.kernel@gmail.com>
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

> so when it is called after early_param, e820_saved get updated too. 
> esp for mpc update.

applied to tip/x86/core, thanks Yinghai.

	Ingo
