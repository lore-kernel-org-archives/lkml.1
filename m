Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbYBVJTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbYBVJTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYBVJTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:19:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44117 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbYBVJTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:19:31 -0500
Date: Fri, 22 Feb 2008 10:19:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Anderson <anderson@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, markus.t.metzger@intel.com,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] ptrace: fix 2.6.25 ptrace_bts_config structure
	declaration
Message-ID: <20080222091913.GC327@elte.hu>
References: <47BDAAB2.3000100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BDAAB2.3000100@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Dave Anderson <anderson@redhat.com> wrote:

> The 2.6.25 ptrace_bts_config structure in asm-x86/ptrace-abi.h is 
> defined with u32 types:

thanks, applied.

	Ingo
