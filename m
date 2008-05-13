Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbYEMNV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbYEMNV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYEMNVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:21:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60482 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbYEMNVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:21:21 -0400
Date: Tue, 13 May 2008 15:21:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rabin Vincent <rabin@rab.in>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched: fix defined-but-unused warning
Message-ID: <20080513132108.GA5809@elte.hu>
References: <20080511002532.GA29515@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511002532.GA29515@debian>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0815]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rabin Vincent <rabin@rab.in> wrote:

> Fix this warning, which appears with !CONFIG_SMP: kernel/sched.c:1216: 
> warning: `init_hrtick' defined but not used

applied, thanks Rabin.

	Ingo
