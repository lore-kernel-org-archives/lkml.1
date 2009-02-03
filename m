Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZBCN0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZBCN0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZBCN0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:26:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58049 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbZBCN0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:26:33 -0500
Date: Tue, 3 Feb 2009 14:26:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/3] trace: better manage the context info for
	events
Message-ID: <20090203132616.GB29046@elte.hu>
References: <20090202222921.GB12082@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090202222921.GB12082@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Impact: make trace_event more convenient for tracers

i've applied your patchset to tip/tracing/bkltrace, thanks guys!

I see that there might be open questions still but it seems the principle 
has been agreed upon and the patches were getting larger and harder to test 
with each daym, so lets do the rest iteratively, ok?

	Ingo
