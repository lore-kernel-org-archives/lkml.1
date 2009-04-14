Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZDNTYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZDNTYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 15:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZDNTYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 15:24:06 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46669 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZDNTYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 15:24:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XeN6KjNSMGQ9uJVeHQPWaEWP4MpUPOgxrgS/mbcC6UaPGk/oNOTpTavk++TUccVYgD
         Fh5TXv+cxl9/Qs5axiXTporMaFzjzHB4qhA6oge8weFDtS2NWx0a0SIO0dexv+LQVDYb
         VStN4jUc79CGTZzzqvGGj0L2f/z3tUtQwE9AU=
Date: Tue, 14 Apr 2009 22:24:40 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS - Update KMEMTRACE pattern after file
	rename
Message-ID: <20090414192440.GA5485@localhost>
References: <1239734197.7994.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239734197.7994.8.camel@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 11:36:37AM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5b4f1dd..d8fe7eb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3267,7 +3267,7 @@ P:	Eduard - Gabriel Munteanu
>  M:	eduard.munteanu@linux360.ro
>  L:	linux-kernel@vger.kernel.org
>  S:	Maintained
> -F:	Documentation/vm/kmemtrace.txt
> +F:	Documentation/trace/kmemtrace.txt
>  F:	include/trace/kmemtrace.h
>  F:	kernel/trace/kmemtrace.c
>  
> 

Thanks, I'm acking it.

Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

