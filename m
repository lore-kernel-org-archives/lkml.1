Return-Path: <linux-kernel-owner+w=401wt.eu-S1765370AbZAQWJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765370AbZAQWJZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 17:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759050AbZAQWJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 17:09:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35670 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758443AbZAQWJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 17:09:13 -0500
Date: Sat, 17 Jan 2009 23:08:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] cpu freq: fix problems with work_on_cpu usage in
	acpi-cpufreq [PULL request]
Message-ID: <20090117220858.GA12374@elte.hu>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <49711A64.3050103@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49711A64.3050103@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4976]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Hi Ingo,
> 
> If you are ready for these, I've pushed them to the cpus4096-for-ingo 
> tree.  (Note it's been renamed.)

that might be fine for v2.6.30, but we need separate patches in a separate 
branch, for all -git relevant fixes - in as safe way as possible.

	Ingo
