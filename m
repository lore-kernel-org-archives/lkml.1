Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYHYIoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYHYIoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 04:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbYHYIoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 04:44:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36963 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbYHYIoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 04:44:16 -0400
Date: Mon, 25 Aug 2008 10:44:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
Message-ID: <20080825084405.GA29195@elte.hu>
References: <48B1D5CA.8000607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48B1D5CA.8000607@gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> The documentation of mmiotrace describes an unimplemented feature 
> which allows the user to write any comments on his trace by writing on 
> a tracing/marker file. Here is an implementation of this idea.
> 
> It applies on last version of tip tree.

hmm ... have you looked at the (recently implemented) ftrace_printk() 
facility?

	Ingo
