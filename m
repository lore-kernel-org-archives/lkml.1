Return-Path: <linux-kernel-owner+w=401wt.eu-S947103AbXHMOjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947103AbXHMOjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970845AbXHMLlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:41:17 -0400
Received: from brick.kernel.dk ([87.55.233.238]:16582 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S970583AbXHMLlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:41:16 -0400
Date: Mon, 13 Aug 2007 13:41:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [488/2many] MAINTAINERS - UNIFORM CDROM DRIVER
Message-ID: <20070813114112.GP23758@kernel.dk>
References: <46bffc42.3KJnrhmdUyXsNsFd%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bffc42.3KJnrhmdUyXsNsFd%joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12 2007, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9bea953..51e9dec 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4625,6 +4625,9 @@ M:	axboe@kernel.dk
>  L:	linux-kernel@vger.kernel.org
>  W:	http://www.kernel.dk
>  S:	Maintained
> +F:	Documentation/cdrom/
> +F:	drivers/cdrom/cdrom.c
> +F:	include/linux/cdrom/h

Also wrong. Joe, please stop posting insane amount of patches. Describe
what you are doing and put them somewhere for people to reach. If you
have to post for review, do a combined patch. Nobody is going to leaf
over 500+ patches.

-- 
Jens Axboe

