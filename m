Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbYFJJ62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbYFJJ62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 05:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYFJJ6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 05:58:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42067 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197AbYFJJ6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:58:18 -0400
Date: Tue, 10 Jun 2008 11:58:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: rostedt@goodmis.org, davem@davemloft.net,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ftrace: remove ftrace_ip_converted
Message-ID: <20080610095809.GG27706@elte.hu>
References: <4842CBA6.6040208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4842CBA6.6040208@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0132]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Abhishek Sagar <sagar.abhishek@gmail.com> wrote:

> Remove the unneeded function ftrace_ip_converted().

applied to tip/tracing/ftrace - thanks.

	Ingo
