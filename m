Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbZG1FfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbZG1FfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 01:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbZG1FfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 01:35:23 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:52193 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbZG1FfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 01:35:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jtoz723M3WMPfiJTjL8zWgfn/vt5DCdX/IzUwAiEt5hZecIZ3HnX/SS0IXhMu6s2PS
         1lWJYwT4nh6DZhE7dHALkNOfjwj0HbE01Qa9yscluLAp3bg6m0VaoVzQpgMu9LNp/ZjS
         SKUwjMMQvX50OVGUiDS/EsdlqTs/JC8CeB84E=
Date: Tue, 28 Jul 2009 13:37:25 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Trevor Keith <tsrk@tsrk.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       trivial@kernel.org
Subject: Re: [PATCH] kbuild: remove extraneous blank line after declaration
	of usage()
Message-ID: <20090728053725.GA6036@cr0.nay.redhat.com>
References: <1248460169.16421.2.camel@tsrk-ibm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248460169.16421.2.camel@tsrk-ibm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 11:29:29AM -0700, Trevor Keith wrote:
>Signed-off-by: Trevor Keith <tsrk@tsrk.net>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Would you mind to fix other coding style problems in the
same file?

Thanks.


>---
> scripts/basic/fixdep.c |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)
>
>diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
>index d7c1b04..27d0924 100644
>--- a/scripts/basic/fixdep.c
>+++ b/scripts/basic/fixdep.c
>@@ -126,7 +126,6 @@ char *depfile;
> char *cmdline;
> 
> static void usage(void)
>-
> {
> 	fprintf(stderr, "Usage: fixdep <depfile> <target> <cmdline>\n");
> 	exit(1);
>-- 
>1.6.0.4
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
