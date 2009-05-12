Return-Path: <linux-kernel-owner+w=401wt.eu-S1760099AbZELKmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099AbZELKmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbZELKm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:42:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51263 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZELKm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:42:27 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter batch values for stats counters
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090512102722.GA11714@elte.hu>
References: <20090512191650.D63E.A69D9226@jp.fujitsu.com> <20090512102722.GA11714@elte.hu>
Message-Id: <20090512194142.D64A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 12 May 2009 19:42:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Cc: Balaji Rao <balajirrao@gmail.com>
> > Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  kernel/sched.c |    9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> Please reuse the commit log formatting fixes i did when i applied 
> your patch. (you should still have that commit notification email)

Oh, I didn't notice this change. I'll resend it. thanks


