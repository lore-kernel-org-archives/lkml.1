Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbXEaNzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbXEaNzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 09:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbXEaNzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 09:55:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42007 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbXEaNzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 09:55:05 -0400
Date: Thu, 31 May 2007 15:54:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, ak@suse.de,
       linux-kernel@vger.kernel.org, nanhai.zou@intel.com,
       asit.k.mallick@intel.com, keith.packard@intel.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86_64 irq: check remote IRR bit before migrating level triggered irq (v3)
Message-ID: <20070531135445.GA2175@elte.hu>
References: <20070517230324.GB8089@linux-os.sc.intel.com> <m1d50h5irm.fsf@ebiederm.dsl.xmission.com> <20070531133426.GA30616@elte.hu> <m1hcpt3xvh.fsf_-_@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hcpt3xvh.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Initial analysis and patch from Nanhai.
> 
> Clean up patch from Suresh.
> 
> Rewritten to be less intrusive, and to contain a big fat comment by 
> Eric.

thanks Erik!

	Ingo
