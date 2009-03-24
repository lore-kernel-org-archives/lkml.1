Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbZCXMLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbZCXMLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZCXMKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:10:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57301 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbZCXMKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:10:54 -0400
Date: Tue, 24 Mar 2009 13:10:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] blktrace: various cleanups and fixes, part 2
Message-ID: <20090324121028.GB32596@elte.hu>
References: <49C893FC.9080905@cn.fujitsu.com> <20090324114938.GP27476@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324114938.GP27476@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Mar 24 2009, Li Zefan wrote:
> > The first part is here:
> > 	http://lkml.org/lkml/2009/3/19/475
> > 
> > And this is the 2nd part, and I still have some pending fixes..
> > 
> > Each patch is a small one, except the last one, which is still not big.
> > 
> > [PATCH 1/5] blktrace: mark ddir_act and what2act const
> > [PATCH 2/5] blktrace: fix wrong calculation of RWBS
> > [PATCH 3/5] blktrace: fix off-by-one bug
> > [PATCH 4/5] blktrace: fix t_error()
> > [PATCH 5/5] blktrace: print human-readable act_mask
> > 
> >  blktrace.c |  127 ++++++++++++++++++++++++++++++++++++-------------------------
> >  1 file changed, 77 insertions(+), 50 deletions(-)
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Looks good, as does your previous series. You can add my acked-by 
> to both series.

Thanks Jens, applied.

	Ingo
