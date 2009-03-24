Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbZCXVdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbZCXVdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbZCXVdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:33:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42916 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbZCXVdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:33:04 -0400
Date: Tue, 24 Mar 2009 22:32:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jody McIntyre <scjody@sun.com>, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] Documentation / sample code fixes for tracepoints
Message-ID: <20090324213243.GA20469@elte.hu>
References: <20090324200027.GH8294@clouds>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324200027.GH8294@clouds>
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


* Jody McIntyre <scjody@sun.com> wrote:

> Fix the tracepoint documentation to refer to "tracepoint-sample" 
> instead of "tracepoint-example" to match what actually exists; fix 
> the directory, and clarify how to compile.
> 
> Change every instance of "example" in the sample tracepoint code 
> to "sample" for consistency.
> 
> Signed-off-by: Jody McIntyre <scjody@sun.com>

Applied to -tip:tracing/docs, thanks Jody! The latest tracing tree 
can be found at:

  http://people.redhat.com/mingo/tip.git/README

Note, the tracepoint examples are a bit outdated - they should 
probably include examples of full-blown field-enumeated 'combo' 
tracepoints like TRACE_EVENT().

Thanks,

	Ingo
