Return-Path: <linux-kernel-owner+w=401wt.eu-S1761577AbXHFHYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577AbXHFHYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbXHFHYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:24:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41701 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbXHFHY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:24:29 -0400
Date: Mon, 6 Aug 2007 09:24:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] tiny sched_getaffinity cleanup
Message-ID: <20070806072424.GI5359@elte.hu>
References: <200707300216.l6U2GZWP024428@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707300216.l6U2GZWP024428@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ulrich Drepper <drepper@redhat.com> wrote:

> Unless I'm missing something quite tricky here's another tiny cleanup.  
> The generated code is not affected (gcc is smart enough) but for 
> people looking over the code it is just irritating to have the extra 
> conditional.

thanks, i've applied your cleanup to my tree.

	Ingo
