Return-Path: <linux-kernel-owner+w=401wt.eu-S1761914AbZFOPVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761914AbZFOPVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbZFOPVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:21:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59605 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758780AbZFOPVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:21:31 -0400
Date: Mon, 15 Jun 2009 17:21:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lennart Poettering <lennart@poettering.net>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scheduler: introduce SCHED_RESET_ON_FORK scheduling
	policy flag
Message-ID: <20090615152127.GA6242@elte.hu>
References: <20090615151747.GA27380@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615151747.GA27380@tango.0pointer.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3440]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lennart Poettering <lennart@poettering.net> wrote:

> (This is the third version of the patch, only change is to move 
> the reset_on_fork flag into a bit hole in the task struct and a 
> rebase on current master, Peter or Ingo, may I ask you to merge 
> that into your trees?)

Could you please send your signed-off-by line?

Thanks,

	Ingo
