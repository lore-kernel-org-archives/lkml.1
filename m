Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbYLHMZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbYLHMZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 07:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbYLHMZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 07:25:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33724 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbYLHMZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 07:25:23 -0500
Date: Mon, 8 Dec 2008 13:25:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: implement a
	print_headers function
Message-ID: <20081208122511.GB16560@elte.hu>
References: <493C70A6.70905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493C70A6.70905@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: provide headers to explain a bit the output
> 
> This patch implements the print_headers callback for the function graph
> tracer. These headers are output according to the current trace options.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied to tip/tracing/function-graph-tracer, thanks Frederic!

	Ingo
