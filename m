Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYLZJ3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYLZJ3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYLZJ3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:29:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53847 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbYLZJ3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:29:09 -0500
Date: Fri, 26 Dec 2008 10:28:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] sysrq: fix ftrace help msg & doc.
Message-ID: <20081226092844.GI27747@elte.hu>
References: <20081224160657.fc391d4b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224160657.fc391d4b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> We have a conventional method of explicitly stating the
> sysrq action key in a sysrq help message, so change
> dump-ftrace-buffer to use that method and add it to
> Documentation/sysrq.txt.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Steven Rostedt <rostedt@goodmis.org>
> cc: Ingo Molnar <mingo@elte.hu>
> ---
>  Documentation/sysrq.txt |    2 ++
>  drivers/char/sysrq.c    |    2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)

applied to tip/tracing/docs, thanks Randy!

	Ingo
