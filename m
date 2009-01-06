Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbZAFIt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbZAFIt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 03:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZAFItQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 03:49:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47949 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbZAFItO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 03:49:14 -0500
Date: Tue, 6 Jan 2009 09:49:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: penberg@cs.helsinki.fi, rostedt@goodmis.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemtrace: Remove the relay version of kmemtrace.
Message-ID: <20090106084905.GB29917@elte.hu>
References: <20090105191330.GA1498@elte.hu> <1231186198-15437-1-git-send-email-eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231186198-15437-1-git-send-email-eduard.munteanu@linux360.ro>
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


* Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> kmemtrace now uses ftrace. This patch removes the relay version.
> 
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  kernel/trace/Kconfig |    1 -
>  mm/Makefile          |    1 -
>  mm/kmemtrace.c       |  333 --------------------------------------------------
>  3 files changed, 0 insertions(+), 335 deletions(-)
>  delete mode 100644 mm/kmemtrace.c

applied to tip/tracing/kmemtrace2, thanks Eduard!

	Ingo
