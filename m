Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYJUMdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYJUMdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYJUMdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:33:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49844 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbYJUMdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:33:14 -0400
Date: Tue, 21 Oct 2008 14:33:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 5/5] tracing/ftrace: Introduce the big kernel lock
	tracer
Message-ID: <20081021123234.GA30726@elte.hu>
References: <48F10B0B.406@gmail.com> <c62985530810210528t416c82b2lbe8471322e8359c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530810210528t416c82b2lbe8471322e8359c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> Are these last 15 days patches submitted to tip put in a wait queue 
> because of the merge window? I hope that the reason for no comment on 
> them is not because they stand in a total irrelevance...

Correct, we froze down for the merge window. Thawing it now :)

	Ingo
