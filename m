Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbZCMBdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbZCMBdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 21:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbZCMBdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 21:33:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51649 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbZCMBdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 21:33:15 -0400
Date: Fri, 13 Mar 2009 02:32:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, dhaval@linux.vnet.ibm.com,
       balbir@in.ibm.com, akpm@linux-foundation.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] cpuset: Check if the cpus allowed is a
	subset of the cpuset's cpus for PF_THREAD_BOUND threads
Message-ID: <20090313013241.GA6107@elte.hu>
References: <20090312174501.GA7821@linux.vnet.ibm.com> <tip-5a98d36112f4301f068b638d6e0db2357f7deb75@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-5a98d36112f4301f068b638d6e0db2357f7deb75@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> Commit-ID:  5a98d36112f4301f068b638d6e0db2357f7deb75
> Gitweb:     http://git.kernel.org/tip/5a98d36112f4301f068b638d6e0db2357f7deb75
> Author:     Dhaval Giani <dhaval@linux.vnet.ibm.com>
> AuthorDate: Thu, 12 Mar 2009 23:15:01 +0530
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 13 Mar 2009 00:21:25 +0100
> 
> cpuset: Check if the cpus allowed is a subset of the cpuset's 
> cpus for PF_THREAD_BOUND threads

Dropped this patch for now - Andrew says it got NAK-ed and he's 
handling it with other fixes.

	Ingo
