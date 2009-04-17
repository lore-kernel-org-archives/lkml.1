Return-Path: <linux-kernel-owner+w=401wt.eu-S932139AbZDQNxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbZDQNxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760983AbZDQNxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:53:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33370 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760954AbZDQNxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:53:14 -0400
Date: Fri, 17 Apr 2009 15:51:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Weidong Han <weidong.han@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Cc: dwmw2@infradead.org, allen.m.kay@intel.com, fenghua.yu@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] docs: add nox2apic back to kernel-parameters.txt
Message-ID: <20090417135156.GC23493@elte.hu>
References: <1239957736-6161-1-git-send-email-weidong.han@intel.com> <1239957736-6161-2-git-send-email-weidong.han@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239957736-6161-2-git-send-email-weidong.han@intel.com>
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


* Weidong Han <weidong.han@intel.com> wrote:

> "nox2apic" was removed from kernel-parameters.txt when Randy moved
> entries to be in alpha order (commit 0cb55ad2). But this early
> parameter is still there, add it back to kernel-parameters.txt.

Randy, this must have been some conflict resolution / patch confict 
merge related loss, right?

Mind double-checking 0cb55ad2 again to make sure no other boot 
parameters were lost during that reordering?

Thanks,

	Ingo
