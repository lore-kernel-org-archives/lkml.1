Return-Path: <linux-kernel-owner+w=401wt.eu-S1752112AbYJ0QLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbYJ0QLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbYJ0QKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:10:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59758 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbYJ0QKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:10:52 -0400
Date: Mon, 27 Oct 2008 17:10:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/6] tracepoint: Check if the probe has been registered
Message-ID: <20081027161024.GV5704@elte.hu>
References: <20081010111631.78545D1BDA2@perso1.free.fr> <20081010140023.GA13137@elte.hu> <c62985530810130243p7d8b1f6dqed1345fb186a4858@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530810130243p7d8b1f6dqed1345fb186a4858@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2372]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/10/10 Ingo Molnar <mingo@elte.hu>:
> > applied to tip/tracing/tracepoints, thanks Frederic!
> 
> Hi Ingo.
> 
> Are you sure it has been applied? It seems to be lost in the sea :)
> 
> Thanks....

should be this one:

f66af45: tracepoint: check if the probe has been registered

	Ingo
