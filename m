Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbYF1Ggq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbYF1Ggq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 02:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbYF1Ggj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 02:36:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38012 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbYF1Ggi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 02:36:38 -0400
Date: Sat, 28 Jun 2008 08:36:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: early res print out alignment v2
Message-ID: <20080628063626.GB15710@elte.hu>
References: <200806251748.06743.yhlu.kernel@gmail.com> <200806252151.29028.yhlu.kernel@gmail.com> <200806262317.48716.yhlu.kernel@gmail.com> <200806271536.54351.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806271536.54351.yhlu.kernel@gmail.com>
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

> v2: fix print info to cont

applied to tip/x86/unify-setup.

>     [ - ] change to xxx - xxx

hm, i changed this back to "[ xxx - yyy ]" - i think it's slightly more 
structured hence more readable.

	Ingo
