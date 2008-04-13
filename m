Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYDMHab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYDMHab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 03:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYDMHaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 03:30:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36970 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbYDMHaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 03:30:21 -0400
Date: Sun, 13 Apr 2008 09:30:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86_64: change _end to end_before_pgt
Message-ID: <20080413073010.GE20036@elte.hu>
References: <200804101506.38139.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804101506.38139.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3505]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> change the _end in compressed vmlinux_64.lds.
> 
> also change _heap to _ebss that is not needed.

thanks Yinghai, applied your cleanup patch.

	Ingo
