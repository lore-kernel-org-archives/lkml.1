Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbZFAWIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbZFAWIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 18:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZFAWIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 18:08:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35553 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbZFAWIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 18:08:18 -0400
Date: Tue, 2 Jun 2009 00:08:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: fix config options
Message-ID: <20090601220807.GD5786@elte.hu>
References: <20090528204128.571984478@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528204128.571984478@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/tracing/ftrace-1 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace-1
> 
> 
> Steven Rostedt (2):
>       tracing: fix config options to not show when automatically selected
>       tracing: combine the default tracers into one config
> 
> ----
>  kernel/trace/Kconfig |   60 +++++++++++++++++++++++++-------------------------
>  1 files changed, 30 insertions(+), 30 deletions(-)

Pulled, thanks Steve!

	Ingo
