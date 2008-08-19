Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYHSALy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYHSALy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbYHSALm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:11:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42956 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbYHSALm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:11:42 -0400
Date: Tue, 19 Aug 2008 02:11:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: rename irq_desc() to to_irq_desc() - fix #3
Message-ID: <20080819001126.GB9914@elte.hu>
References: <1219092290-30154-1-git-send-email-yhlu.kernel@gmail.com> <1219092290-30154-2-git-send-email-yhlu.kernel@gmail.com> <1219092290-30154-3-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219092290-30154-3-git-send-email-yhlu.kernel@gmail.com>
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

> add create_irq_nr, and retore create_irq to old

applied all 3 patches to tip/irq/sparseirq - thanks Yinghai!

	Ingo
