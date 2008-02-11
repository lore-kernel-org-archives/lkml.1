Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbYBKKNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbYBKKNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYBKKN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:13:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40731 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbYBKKN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:13:26 -0500
Date: Mon, 11 Feb 2008 11:13:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: remove unused tracing_sched_switch_enabled
Message-ID: <20080211101313.GB32181@elte.hu>
References: <20080210072050.GN4100@elte.hu> <20080210154923.GA15451@kernel.sg> <20080210155505.GA16205@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210155505.GA16205@kernel.sg>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1675]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eugene Teo <eugeneteo@kernel.sg> wrote:

> <quote sender="Eugene Teo">
> > tracing_sched_switch_enabled isn't used anywhere.
> > 
> > Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
> 
> Sorry, I forgot to remove the variable declaration. Here's a resend:
> 
> tracing_sched_switch_enabled isn't used anywhere.

thanks, applied.

	Ingo
