Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbZBJM1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbZBJM1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZBJM1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:27:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50548 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbZBJM1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:27:38 -0500
Date: Tue, 10 Feb 2009 13:27:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 1/2] tracing/sysprof: add missing
	tracing_{start,stop}_record_cmdline()
Message-ID: <20090210122726.GA21531@elte.hu>
References: <4990fdb7.0e0f660a.1d27.5399@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4990fdb7.0e0f660a.1d27.5399@mx.google.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Add the missing pair tracing_{start,stop}_record_cmdline() to record well
> the cmdline associated with pid.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace_sysprof.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)

applied to tip/tracing/sysprof, thanks Frederic!

	Ingo
