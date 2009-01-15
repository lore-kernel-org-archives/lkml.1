Return-Path: <linux-kernel-owner+w=401wt.eu-S1764295AbZAOLBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764295AbZAOLBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760611AbZAOLBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:01:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44184 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759326AbZAOLA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:00:59 -0500
Date: Thu, 15 Jan 2009 12:00:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched: introduce avg_wakeup
Message-ID: <20090115110045.GB16253@elte.hu>
References: <20090114113917.199690328@chello.nl> <20090114114026.969559732@chello.nl> <1231934371.7141.29.camel@twins> <1231934594.7141.30.camel@twins> <20090114120558.GA5711@elte.hu> <1231939208.14825.7.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231939208.14825.7.camel@laptop>
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

> On Wed, 2009-01-14 at 13:05 +0100, Ingo Molnar wrote:
> 
> > mind sending a delta against the first submission? Whenever you are done 
> > with the lunch stuff ;-)
> 
> Compile fix and cleanup, actually compile tested too :-)

applied, thanks Peter!

	Ingo
