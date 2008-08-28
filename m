Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYH1Mnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYH1Mnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 08:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbYH1Mnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 08:43:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39249 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbYH1Mng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 08:43:36 -0400
Date: Thu, 28 Aug 2008 14:42:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: disable tracing for hibernation
Message-ID: <20080828124246.GA13825@elte.hu>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <alpine.DEB.1.10.0808270844500.7871@gandalf.stny.rr.com> <200808271526.46868.rjw@sisk.pl> <200808281439.13959.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808281439.13959.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> ftrace: disable tracing for hibernation
>     
> In accordance with commit f42ac38c59e0a03d6da0c24a63fb211393f484b0
> ("ftrace: disable tracing for suspend to ram"), disable tracing
> around the suspend code in hibernation code paths.
>     
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

applied it to tip/tracing/urgent - thanks Rafael!

	Ingo
