Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbYEaOnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbYEaOnH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 10:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYEaOm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 10:42:59 -0400
Received: from fmailhost04.isp.att.net ([204.127.217.104]:55457 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYEaOm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 10:42:58 -0400
X-Originating-IP: [74.251.4.135]
Date: Sat, 31 May 2008 09:42:53 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Paul Jackson <pj@sgi.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Randy Dunlap" <rdunlap@xenotime.net>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] doc: document the kernel-doc conventions for kernel
 hackers
Message-ID: <20080531094253.30ae975e@osprey.hogchain.net>
In-Reply-To: <20080530221941.28920.30102.sendpatchset@polaris-admin.engr.sgi.com>
References: <20080530221941.28920.30102.sendpatchset@polaris-admin.engr.sgi.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008 15:19:41 -0700
Paul Jackson <pj@sgi.com> wrote:

> From: Paul Jackson <pj@sgi.com>
> 
> Provide documentation of the kernel-doc documentation conventions
> oriented to kernel hackers.
> 
> Since I figure that there will be more people reading this
> kernel-doc-nano-HOWTO.txt file who are kernel developers focused
> on the rest of the kernel, than there will be readers of this
> file who are documentation developers extracting that embedded
> kernel-doc documentation, I have taken the liberty of making
> the new section added here:
> 
>   How to format kernel-doc comments
> 
> the first section of the kernel-doc-nano-HOWTO.txt file.
> 
> This first section is intended to introduce, motivate and
> provide basic usage of the kernel-doc mechanism for kernel
> hackers developing other portions of the kernel.
> 
> Signed-off-by: Paul Jackson <pj@sgi.com>
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> ---
>  Documentation/kernel-doc-nano-HOWTO.txt |   99
> ++++++++++++++++++++++++++++++++ 1 file changed, 99 insertions(+)
> 
> --- linux-2.6.orig/Documentation/kernel-doc-nano-HOWTO.txt
> 2008-05-30 08:47:13.000000000 -0700 +++
> linux-2.6/Documentation/kernel-doc-nano-HOWTO.txt	2008-05-30
> 15:14:33.281447922 -0700 @@ -1,6 +1,105 @@ kernel-doc nano-HOWTO
>  =====================
>  
> +How to format kernel-doc comments
> +---------------------------------
> +
> +In order to provide an embedded, 'C' friendly, easy to maintain,
> +but consistent and extractable documentation of the functions and
> +data structures in the Linux kernel, the Linux kernel has adopted
> +a consistent style for documenting functions and their parameters,
> +and structures and their members.
> +
> +The format for this documentation is called the kernel-doc format.
> +It as documented in this Documentation/kernel-doc-nano-HOWTO.txt

s/as/is
