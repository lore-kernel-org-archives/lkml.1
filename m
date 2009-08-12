Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbZHLJc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbZHLJc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbZHLJc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:32:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32852 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbZHLJc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:32:58 -0400
Date: Wed, 12 Aug 2009 11:32:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [GIT PULL] perf tools: Factorize common code
Message-ID: <20090812093231.GA14734@elte.hu>
References: <1250069162-13099-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250069162-13099-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> This set factorizes the common definition of structs, functions, 
> variables inside perf tools to make it easier for perf trace to be 
> created.
> 
> I guess this patchset only factorizes 10 % of what could be done, 
> the largest part is the intersection between perf report and perf 
> annotate. It's a lot of work.
> 
> I guess I will do the rest in separate patchsets while writing 
> perf trace.

Pulled, thanks Frederic!

	Ingo
