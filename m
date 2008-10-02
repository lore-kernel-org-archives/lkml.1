Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYJBMCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYJBMCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 08:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYJBMCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 08:02:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33290 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbYJBMCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 08:02:30 -0400
Date: Thu, 2 Oct 2008 14:02:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip 1/2] Tracing/fastboot: Change the printing of boot
	tracer according to bootgraph.pl
Message-ID: <20081002120218.GA14322@elte.hu>
References: <48E4A988.5060300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E4A988.5060300@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0034]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Change the boot tracer printing to make it parsable for
> the scripts/bootgraph.pl script.
> We have now to output two lines for each initcall, according to the
> printk in do_one_initcall() in init/main.c
> We need now the call's time and the return's time.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied to tip/tracing/fastboot, thanks Frederic!

	Ingo
