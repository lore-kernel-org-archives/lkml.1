Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbYLPLQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbYLPLQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbYLPLPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:15:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52735 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509AbYLPLPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:15:52 -0500
Date: Tue, 16 Dec 2008 12:15:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] cpuacct: export percpu cpuacct cgroup stats
Message-ID: <20081216111544.GD4299@elte.hu>
References: <b040c32a0812152204x3b3d378aie7a1898aa67c4278@mail.gmail.com> <b040c32a0812152306p6b72e1d6r548daa66f27f24d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0812152306p6b72e1d6r548daa66f27f24d6@mail.gmail.com>
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


* Ken Chen <kenchen@google.com> wrote:

> This patch export per-cpu CPU cycle usage for a given cpuacct cgroup. 
> There is a need for a user space monitor daemon to track group CPU usage 
> on per-cpu base.  It is also useful for monitoring CFS load balancer 
> behavior by tracking per CPU group usage.
> 
> Signed-off-by: Ken Chen <kenchen@google.com>
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>

applied to tip/sched/core, thanks Ken!

	Ingo
