Return-Path: <linux-kernel-owner+w=401wt.eu-S974658AbXHMTA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S974658AbXHMTA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1033531AbXHMS5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:57:08 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:45374 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938984AbXHMS5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:57:04 -0400
Date: Mon, 13 Aug 2007 11:55:36 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: joe@perches.com
Cc: xen-devel@lists.xensource.com, virtualization@lists.osdl.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeremy@xensource.com, chrisw@sous-sol.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [545/2many] MAINTAINERS - XEN HYPERVISOR INTERFACE
Message-ID: <20070813185536.GH3672@sequoia.sous-sol.org>
References: <46bffcb5.o/KKCq3EZH4S47k3%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bffcb5.o/KKCq3EZH4S47k3%joe@perches.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* joe@perches.com (joe@perches.com) wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e4e1cc3..8395aba 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5153,6 +5153,11 @@ M:	chrisw@sous-sol.org
>  L:	virtualization@lists.osdl.org
>  L:	xen-devel@lists.xensource.com
>  S:	Supported
> +F:	arch/i386/xen/
> +F:	drivers/*/xen-*front.c
> +F:	drivers/xen/
> +F:	include/asm-i386/xen/
> +F:	include/xen/

I think this data will easily become stale.  What is the point again?
