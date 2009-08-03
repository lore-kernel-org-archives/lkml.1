Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbZHCWoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbZHCWoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 18:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZHCWoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 18:44:10 -0400
Received: from xenotime.net ([72.52.64.118]:46304 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753200AbZHCWoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 18:44:09 -0400
Date: Mon, 3 Aug 2009 15:44:10 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Michael Brunner <mibru@gmx.de>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] SubmittingPatches: Fix reference to renumbered step
Message-Id: <20090803154410.734d8af6.rdunlap@xenotime.net>
In-Reply-To: <20090804004111.022dc119@mail.gmx.de>
References: <20090804004111.022dc119@mail.gmx.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Aug 2009 00:41:11 +0200 Michael Brunner wrote:

> This patch fixes a reference to step "Select e-mail destination." which
> has been renumbered from 4) to 5) in linux-2.6.22.
> 
> Signed-off-by: Michael Brunner <mibru@gmx.de>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Jiri, will you merge this, please?


> ---
> 
>  Documentation/SubmittingPatches |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index 5c555a8..b7f9d3b 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -183,7 +183,7 @@ the MAN-PAGES maintainer (as listed in the MAINTAINERS file)
>  a man-pages patch, or at least a notification of the change,
>  so that some information makes its way into the manual pages.
>  
> -Even if the maintainer did not respond in step #4, make sure to ALWAYS
> +Even if the maintainer did not respond in step #5, make sure to ALWAYS
>  copy the maintainer when you change their code.
>  
>  For small patches you may want to CC the Trivial Patch Monkey


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
