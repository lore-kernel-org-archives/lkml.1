Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYGRKai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYGRKai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbYGRKab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:30:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52257 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbYGRKab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:30:31 -0400
Date: Fri, 18 Jul 2008 12:30:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [sched-devel, patch-rfc] rework #2 of "prioritize
	non-migratable tasks over migratable ones"
Message-ID: <20080718103018.GW6875@elte.hu>
References: <1214947935.5658.11.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214947935.5658.11.camel@earth>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0107]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> Finally, this new version compiles and boots (applied a minor 
> compilation fix). Functionality is not yet fully tested though.
> 
> It's on top of today's tip tree.
> 
> Any objections to this approach?

applied to tip/sched/devel - thanks Dmitry.

	Ingo
