Return-Path: <linux-kernel-owner+w=401wt.eu-S1762851AbZCXU0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762851AbZCXU0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763029AbZCXU0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:26:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34408 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762237AbZCXU0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:26:01 -0400
Date: Tue, 24 Mar 2009 21:25:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tim Bird <tim.bird@am.sony.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
Message-ID: <20090324202539.GA11672@elte.hu>
References: <49C936CA.8070800@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C936CA.8070800@am.sony.com>
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


* Tim Bird <tim.bird@am.sony.com> wrote:

> My ultimate goal is to add function duration filtering, which is 
> one of the nicer features of KFT (an older tracer I used to 
> maintain out-of-mainline).  With all the ftrace and ringbuffer 
> support already in mainline, this shouldn't be too hard, but I 
> need to start with basic graph support on ARM first.

ah, function duration filtering - is that to only show functions 
which have a duration beyond a certain (runtime configurable) value?

	Ingo
