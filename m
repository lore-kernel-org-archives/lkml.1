Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbZLNQ13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbZLNQ13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757802AbZLNQ12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:27:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35869 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907AbZLNQ11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:27:27 -0500
Date: Mon, 14 Dec 2009 17:27:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: stack tracing
Message-ID: <20091214162713.GA31060@elte.hu>
References: <20091211184018.738768739@goodmis.org>
 <20091214161257.GA20097@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214161257.GA20097@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, i noticed this new warning:

 kernel/trace/trace.c: In function 'trace_dump_stack':
 kernel/trace/trace.c:1161: warning: 'return' with a value, in function returning void

	Ingo
