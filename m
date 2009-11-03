Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbZKCHma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbZKCHma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbZKCHma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:42:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38170 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486AbZKCHm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:42:29 -0500
Date: Tue, 3 Nov 2009 08:42:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: Re: [RFC][PATCH 6/7] Adding general performance benchmarking
	subsystem to perf.
Message-ID: <20091103074218.GF19928@elte.hu>
References: <20091103.133849.430771458054376230.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103.133849.430771458054376230.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> Adding general performance benchmarking subsystem to perf.
> This patch adds new builtin-bench-messaging.c
> 
> builtin-bench-messaging.c is a benchmark program
> to measure performance of scheduler and IPC mechanisms.
> This benchmark is based on hackbench by Rusty Russell.

a small suggestion: would you mind to include sample output in the 
commit log that adds a new suite component? That way people can get a 
'ok, this is the new feature i'm getting!' first impression during 
review - without having to try out the patch itself.

Thanks,

	Ingo
