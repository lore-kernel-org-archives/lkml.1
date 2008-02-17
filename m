Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbYBQQQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbYBQQQa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 11:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYBQQQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 11:16:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42215 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbYBQQQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 11:16:19 -0500
Date: Sun, 17 Feb 2008 17:16:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fix cpu info in dmesg
Message-ID: <20080217161602.GA6006@elte.hu>
References: <20080201203142.GA6305@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201203142.GA6305@joi>
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


* Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> I'm not sure whether it's the right fix, but it doesn't make sense to call
> print_cpu_info without leading printk...

thanks, applied.

	Ingo
