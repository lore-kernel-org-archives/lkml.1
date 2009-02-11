Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZBKJQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZBKJQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 04:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbZBKJQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 04:16:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47036 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbZBKJQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 04:16:24 -0500
Date: Wed, 11 Feb 2009 10:16:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hannes Eder <hannes@hanneseder.net>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/3] trace: fix sparse warnings
Message-ID: <20090211091613.GJ21105@elte.hu>
References: <20090210184214.28131.90564.stgit@vmbox.hanneseder.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210184214.28131.90564.stgit@vmbox.hanneseder.net>
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


* Hannes Eder <hannes@hanneseder.net> wrote:

> The following series fixes some sparse warnings in kernel/trace.
> 
> ---
> 
> Hannes Eder (3):
>       trace: fix sparce warning: attribute function with __acquires/__releases
>       trace: fix sparse warnings: fix (un-)signedness
>       trace: fix sparse warnings: make symbols static
> 
> 
>  kernel/trace/ring_buffer.c |    8 ++++----
>  kernel/trace/trace.c       |   18 +++++++++++-------
>  2 files changed, 15 insertions(+), 11 deletions(-)

Applied to tip:tracing/ftrace (with minor edits), thanks Hannes!

	Ingo
