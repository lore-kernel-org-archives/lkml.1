Return-Path: <linux-kernel-owner+w=401wt.eu-S969449AbXHMUri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969449AbXHMUri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943149AbXHMUqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:46:16 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41136 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S940052AbXHMUqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:46:12 -0400
Date: Mon, 13 Aug 2007 13:46:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: joe@perches.com
cc: torvalds@linux-foundation.org, penberg@cs.helsinki.fi, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [438/2many] MAINTAINERS - SLAB ALLOCATOR
In-Reply-To: <46bffbc9.9Jtz7kOTKn1mqlkq%joe@perches.com>
Message-ID: <Pine.LNX.4.64.0708131345130.27728@schroedinger.engr.sgi.com>
References: <46bffbc9.9Jtz7kOTKn1mqlkq%joe@perches.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007, joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b2dd6f5..a3c6123 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4168,6 +4168,8 @@ P:	Pekka Enberg
>  M:	penberg@cs.helsinki.fi
>  L:	linux-mm@kvack.org
>  S:	Maintained
> +F:	include/linux/slab*

Use include/linux/sl?b*.h 

> +F:	mm/slab.c

Use mm/sl?b.c ?

Otherwise this does not include slub f.e.

