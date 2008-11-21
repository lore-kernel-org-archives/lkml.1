Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYKUIA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYKUIA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYKUIAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:00:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51990 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbYKUIAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:00:15 -0500
Date: Fri, 21 Nov 2008 09:00:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lockdep: consistent alignement for lockdep info
Message-ID: <20081121080007.GE16242@elte.hu>
References: <492669EC.6020101@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492669EC.6020101@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Just feel odd that not all lines of lockdep info are aligned.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/lockdep.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

applied to tip/core/urgent, thanks!

	Ingo
