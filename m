Return-Path: <linux-kernel-owner+w=401wt.eu-S1757723AbZF2IWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbZF2IWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbZF2IWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:22:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58608 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbZF2IWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:22:00 -0400
Date: Mon, 29 Jun 2009 10:21:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/fastboot: document the need of initcall_debug
Message-ID: <20090629082152.GA2921@elte.hu>
References: <4A48735E.9050002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A48735E.9050002@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> To use boot tracer, one should pass initcall_debug as well as
> ftrace=initcall to the command line.

I think both should be auto-enabled if BOOT_TRACER is enabled, for 
ease of use - agreed?

	Ingo
