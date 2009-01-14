Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbZANGCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbZANGCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 01:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbZANGCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 01:02:38 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:48341 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752247AbZANGCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 01:02:38 -0500
Date: Wed, 14 Jan 2009 14:59:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] MAINTAINERS - Add FTRACE git
Message-ID: <20090114055954.GA7039@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Joe Perches <joe@perches.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
References: <1231878498-25171-1-git-send-email-joe@perches.com> <1231878498-25171-9-git-send-email-joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231878498-25171-9-git-send-email-joe@perches.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 12:28:16PM -0800, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ceeeb8c..6e051c3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2189,6 +2189,7 @@ F:	fs/freevxfs/
>  FTRACE
>  P:	Steven Rostedt
>  M:	rostedt@goodmis.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git
>  S:	Maintained
>  F:	Documentation/ftrace.txt
>  F:	arch/*/*/*/ftrace.h

This sort of thing only makes sense if you include the topic branch for
the tree in question. While it is true that ftrace development happens in
this tree, people looking at ftrace may not want to sort through the
hundreds of unrelated topic branches in the process. I say this as
someone that does not want to sort through hundreds of unrelated topic
branches in search of ftrace code ;-)
