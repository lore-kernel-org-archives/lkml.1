Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbYBJHUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbYBJHUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbYBJHUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:20:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35366 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180AbYBJHUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:20:05 -0500
Date: Sun, 10 Feb 2008 08:19:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Steven Rostedt <rostedt@goodmis.org>
Subject: [00/19] latency tracer
Message-ID: <20080210071949.GA4100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0068]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


this is the latency tracer that has been also posted at:

    http://lkml.org/lkml/2008/2/8/435
    http://lkml.org/lkml/2008/2/9/127

the tree can be pulled from:

    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

about 9 iterations of this have been posted to lkml in the past month,
this is the most recent iteration.

	Ingo
