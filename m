Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYEZJBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYEZJBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 05:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYEZJBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 05:01:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38808 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbYEZJBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 05:01:36 -0400
Date: Mon, 26 May 2008 11:01:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Clark Williams <clark.williams@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RT] remove user_trace_stop
Message-ID: <20080526090122.GD13529@elte.hu>
References: <Pine.LNX.4.58.0805240217130.1841@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0805240217130.1841@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0437]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> [ Doing a full config compile I came up with this ]
> 
> Remove user_trace_stop that was more of a hack to debug xrun 
> latencies.

btw., would be nice to have an ftrace/xrun or ftrace/audio plugin which 
would be for the targeted tracing of sound latencies.

	Ingo
