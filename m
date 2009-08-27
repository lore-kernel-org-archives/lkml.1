Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbZH0QgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbZH0QgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 12:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZH0QgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 12:36:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37915 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbZH0QgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 12:36:21 -0400
Date: Thu, 27 Aug 2009 18:36:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <gregory.haskins@gmail.com>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE: regression in 31-rc7
Message-ID: <20090827163618.GA30530@elte.hu>
References: <4A96B55C.10001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A96B55C.10001@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <gregory.haskins@gmail.com> wrote:

> Hi Steve,
> 
> I just moved from -rc6 to -rc7, and I noticed that the function-graph
> tracer suddenly stopped working properly:  I do not see any output from
> seeming most things except a handful of interrupt related events.  I
> currently believe it may be an issue with tracing modules.
> 
> I haven't had a chance to bisect yet, but I did confirm that reverting
> the -rc7 merge restores the previous tracer behavior.  Any help/pointers
> appreciated.

also Cc:-ed Frederic.

	Ingo
