Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbYFSKMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbYFSKMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 06:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbYFSKMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 06:12:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40376 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022AbYFSKMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 06:12:34 -0400
Date: Thu, 19 Jun 2008 12:12:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dario Faggioli <raistlin@linux.it>,
       Michael Trimarchi <trimarchimichael@yahoo.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: NULL pointer dereference while setting sched_rt_period_us
Message-ID: <20080619101224.GG15228@elte.hu>
References: <1213773519.5371.8.camel@Palanthas.Krynn> <1213775311.16944.199.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213775311.16944.199.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2008-06-18 at 09:18 +0200, Dario Faggioli wrote:
> > Hi all,
> 
> Thanks! I'll push it fwd with my other rt-group fixes

applied Dario's fix to tip/sched/urgent:

  http://people.redhat.com/mingo/tip.git/README

thanks Dario and Peter.

	Ingo
