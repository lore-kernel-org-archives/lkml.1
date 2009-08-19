Return-Path: <linux-kernel-owner+w=401wt.eu-S1751686AbZHSKiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbZHSKiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 06:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZHSKiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 06:38:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51931 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbZHSKiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 06:38:07 -0400
Date: Wed, 19 Aug 2009 12:37:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree with Linus' tree
Message-ID: <20090819103755.GC27405@elte.hu>
References: <20090819160758.f23f2e8a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090819160758.f23f2e8a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in
> kernel/irq/manage.c between commit
> 69ab849439b506cd8dd2879527fdb64d95dd5211 ("genirq: Wake up irq thread
> after action has been installed") from Linus' tree and commit
> 3c26caa7409ad5367b257de3d7943551d4a959ee ("genirq: Do not wakeup irq
> thread from __setup_irq() and set action->irq") from the tip tree.
> 
> I used the version from Linus' tree (as seems to have been done in
> tip:master).

Yeah - that's the right resolution - thanks Stephen.

	Ingo
