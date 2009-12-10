Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbZLJHa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbZLJHa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760462AbZLJHa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:30:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58222 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760606AbZLJHa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:30:57 -0500
Date: Thu, 10 Dec 2009 08:30:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf kmem: Show usage if no option is specified
Message-ID: <20091210073059.GG16874@elte.hu>
References: <4B20A195.8030106@cn.fujitsu.com>
 <4B20A1EF.9080300@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B20A1EF.9080300@cs.helsinki.fi>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Li Zefan kirjoitti:
> >As Ingo suggested, make "perf kmem" show help information.
> >"perf kmem stat [--caller] [--alloc] .." will show memory
> >statistics.
> >
> >Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Applied, thanks!

	Ingo
