Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbZHMJwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbZHMJwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbZHMJwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:52:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbZHMJwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:52:05 -0400
Date: Thu, 13 Aug 2009 11:52:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Trevor Keith <tsrk@tsrk.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: remove extraneous blank line after declaration
 of usage()
In-Reply-To: <1248460169.16421.2.camel@tsrk-ibm>
Message-ID: <alpine.LNX.2.00.0908131151330.25797@wotan.suse.de>
References: <1248460169.16421.2.camel@tsrk-ibm>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009, Trevor Keith wrote:

> Signed-off-by: Trevor Keith <tsrk@tsrk.net>
> ---
>  scripts/basic/fixdep.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
> index d7c1b04..27d0924 100644
> --- a/scripts/basic/fixdep.c
> +++ b/scripts/basic/fixdep.c
> @@ -126,7 +126,6 @@ char *depfile;
>  char *cmdline;
>  
>  static void usage(void)
> -
>  {
>  	fprintf(stderr, "Usage: fixdep <depfile> <target> <cmdline>\n");
>  	exit(1);

Haven't seen this in linux-next up to today, so I have applied it to 
trivial queue.

-- 
Jiri Kosina
SUSE Labs
