Return-Path: <linux-kernel-owner+w=401wt.eu-S1762226AbZANLr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762226AbZANLr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758720AbZANLrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:47:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36264 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759291AbZANLro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:47:44 -0500
Date: Wed, 14 Jan 2009 12:47:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] prefer wakers -v2
Message-ID: <20090114114738.GH8625@elte.hu>
References: <20090114113917.199690328@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114113917.199690328@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> OK, so lets try this again...

applied them to tip/sched/core:

 c4cddec: sched: prefer wakers
 6a70714: sched: introduce avg_wakeup

Mike, what's your review/performance/interactivity verdict?

	Ingo
