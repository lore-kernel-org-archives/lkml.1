Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbZBCFcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbZBCFcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZBCFco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:32:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39933 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZBCFcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:32:43 -0500
Date: Tue, 3 Feb 2009 06:32:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, mingo <mingo@redhat.com>,
       akpm <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched: add missing kernel-doc in sched.h
Message-ID: <20090203053224.GE28361@elte.hu>
References: <20090202160029.dfea8898.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090202160029.dfea8898.randy.dunlap@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add kernel-doc notation for @lock:
> 
> include/linux/sched.h:457: No description found for parameter 'lock'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  include/linux/sched.h |    1 +
>  1 file changed, 1 insertion(+)

Applied to tip/sched/urgent, thanks Randy!

	Ingo
