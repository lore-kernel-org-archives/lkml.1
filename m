Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZAZUb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZAZUb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 15:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZAZUbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 15:31:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40330 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbZAZUbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 15:31:49 -0500
Date: Mon, 26 Jan 2009 21:31:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] blktrace: the ftrace interface needs
	CONFIG_TRACING
Message-ID: <20090126203140.GC8867@elte.hu>
References: <20090126202549.GC11038@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126202549.GC11038@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Resend, the first time I forgot to add [PATCH tip 1/1].
> 
> Ingo, this fix that problem you reported me, where a .config didn't had 
> CONFIG_TRACING selected.

yep - i already applied the first version and it does the trick for the 
build failure. (I changed the Impact line to "Impact: build fix" - as that 
really is the goal and effect of the commit.)

Thanks,

	Ingo
