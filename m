Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbZBSM0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbZBSM0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbZBSMZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:25:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53772 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbZBSMZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:25:55 -0500
Date: Thu, 19 Feb 2009 13:25:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] tracing/function-graph-tracer: provide
	documentation for the function graph tracer
Message-ID: <20090219122543.GA18972@elte.hu>
References: <499ba227.077e420a.56d6.ffffc38b@mx.google.com> <alpine.DEB.1.10.0902181229550.11411@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902181229550.11411@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Thanks Frederic,
> 
> I'll go through it later. I Really need to rewrite ftrace.txt 
> to match what is in 29 now. That will soon be a high priority 
> for me.

Note, i applied Frederic's patch and cleaned up ftrace.txt 
typography a bit. If you update the file then please update it 
to the latest status quo - it's too late for .29 documentation 
updates.

	Ingo
