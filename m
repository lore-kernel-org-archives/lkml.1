Return-Path: <linux-kernel-owner+w=401wt.eu-S1760819AbZFZOsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819AbZFZOsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759643AbZFZOsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:48:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34174 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758777AbZFZOs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:48:29 -0400
Date: Fri, 26 Jun 2009 16:48:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 0/2] perfcounter: callchains with perf report
Message-ID: <20090626144822.GC19477@elte.hu>
References: <1246026481-8314-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246026481-8314-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0025]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi,
> 
> Here is a first shot for the sorted callchains per entries handling
> with per report.

ok, this is already useful at displaying the raw data.

> I'll continue to improve it:
> 
> - symbol resolution
> - profit we have a tree to display a better graph hierarchy
> - let the user provide a limit for hit percentage, depth, number of
>   backtraces, etc...
> - better output
> - colors
> - and so on....

nice plans! :)

	Ingo
