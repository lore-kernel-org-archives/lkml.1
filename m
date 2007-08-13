Return-Path: <linux-kernel-owner+w=401wt.eu-S947615AbXHMQRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947615AbXHMQRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947832AbXHMPBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:01:19 -0400
Received: from cnc.isely.net ([64.81.146.143]:38347 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S944685AbXHMPBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:01:15 -0400
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 11:01:14 EDT
Date: Mon, 13 Aug 2007 09:55:40 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: joe@perches.com
cc: Video4Linux list <video4linux-list@redhat.com>,
       torvalds@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, Mike Isely at pobox <isely@pobox.com>
Subject: Re: [PATCH] [393/2many] MAINTAINERS - PVRUSB2 VIDEO4LINUX DRIVER
In-Reply-To: <46bffb73.u23bbvN6qGflEzaJ%joe@perches.com>
Message-ID: <Pine.LNX.4.64.0708130955100.10343@cnc.isely.net>
References: <46bffb73.u23bbvN6qGflEzaJ%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Mike Isely <isely@pobox.com>

On Sun, 12 Aug 2007, joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 62b6ede..3889034 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3760,6 +3760,8 @@ L:	pvrusb2@isely.net	(subscribers-only)
>  L:	video4linux-list@redhat.com
>  W:	http://www.isely.net/pvrusb2/
>  S:	Maintained
> +F:	Documentation/video4linux/README.pvrusb2
> +F:	drivers/media/video/pvrusb2/
>  
>  PXA2xx SUPPORT
>  P:	Nicolas Pitre
> 

-- 
                        |         Mike Isely          |     PGP fingerprint
     Spammers Die!!     |                             | 03 54 43 4D 75 E5 CC 92
                        |   isely @ pobox (dot) com   | 71 16 01 E2 B5 F5 C1 E8
                        |                             |
