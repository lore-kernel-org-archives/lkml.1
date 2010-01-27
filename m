Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416Ab0A0Ov6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab0A0Ov6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405Ab0A0Ov4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:51:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42298 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab0A0Ovz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:51:55 -0500
Date: Wed, 27 Jan 2010 12:51:50 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: John Kacur <jkacur@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Ignore perf-archive
Message-ID: <20100127145150.GA26842@ghostprotocols.net>
References: <1264601514-9287-1-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264601514-9287-1-git-send-email-jkacur@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 27, 2010 at 03:11:54PM +0100, John Kacur escreveu:
> Tell git to ignore perf-archive.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  tools/perf/.gitignore |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
> index 124760b..e1d60d7 100644
> --- a/tools/perf/.gitignore
> +++ b/tools/perf/.gitignore
> @@ -14,6 +14,7 @@ perf*.html
>  common-cmds.h
>  perf.data
>  perf.data.old
> +perf-archive
>  tags
>  TAGS
>  cscope*

Thanks, will be in my next batch to Ingo.

- Arnaldo
