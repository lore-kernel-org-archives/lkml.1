Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYJTMGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYJTMGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYJTMFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:05:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53832 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbYJTMFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:05:52 -0400
Date: Mon, 20 Oct 2008 14:05:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH 0/4] pending scheduler updates
Message-ID: <20081020120538.GD10594@elte.hu>
References: <20081017172701.047939625@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017172701.047939625@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0483]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Please apply

applied these to tip/sched/urgent:

 f9c0b09: sched: revert back to per-rq vruntime
 a4c2f00: sched: fair scheduler should not resched rt tasks
 ffda12a: sched: optimize group load balancer

(will wait with 4/4 until you and Mike come to a verdict.)

thanks Peter,

	Ingo
