Return-Path: <linux-kernel-owner+w=401wt.eu-S1761201AbZFPTgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761201AbZFPTgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZFPTg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:36:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34393 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbZFPTg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:36:27 -0400
Date: Tue, 16 Jun 2009 21:36:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [GIT PULL] tracing/filters/ringbuffer: updates for
	2.6.31
Message-ID: <20090616193621.GA21246@elte.hu>
References: <20090616175133.317996432@goodmis.org> <20090616192821.GA12699@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090616192821.GA12699@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0210]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hm, there's a new build failure with this lot:

kernel/trace/ring_buffer.c:1298: error: ‘event’ undeclared (first use in this function)
kernel/trace/ring_buffer.c:1298: error: (Each undeclared identifier is reported only once
kernel/trace/ring_buffer.c:1298: error: for each function it appears in.)

	Ingo
