Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbZB1HV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbZB1HV4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 02:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZB1HVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 02:21:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59898 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZB1HVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 02:21:47 -0500
Date: Sat, 28 Feb 2009 08:21:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Luis Henriques <henrix@sapo.pt>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] tracing: remove unused code
Message-ID: <20090228072137.GD9351@elte.hu>
References: <20090227202923.GA3826@hades.domain.com> <alpine.DEB.2.00.0902271535440.13395@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902271535440.13395@gandalf.stny.rr.com>
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

> Thanks Luis,
> 
> But before I remove this code, I want to move it to be 
> activated by tracing options. The irqsoff tracer (and other 
> latency tracers) are pretty useless without it.

sounds good.

	Ingo
