Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbYH1Jgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbYH1Jgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 05:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbYH1Jgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 05:36:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34781 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYH1Jgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 05:36:40 -0400
Date: Thu, 28 Aug 2008 11:36:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Korty <joe.korty@ccur.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] make might_sleep() display the oopsing process
Message-ID: <20080828093628.GA28783@elte.hu>
References: <20080827152139.GA11460@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827152139.GA11460@tsunami.ccur.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Korty <joe.korty@ccur.com> wrote:

> Expand might_sleep's printk to indicate the oopsing process.

good idea - applied to tip/sched/devel - thanks Joe.

	Ingo
