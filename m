Return-Path: <linux-kernel-owner+w=401wt.eu-S965116AbXHMPNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965116AbXHMPNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971556AbXHMMzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:55:48 -0400
Received: from n152-u15.estnet.bg ([89.253.152.15]:3781 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765677AbXHMMzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:55:40 -0400
Date: Mon, 13 Aug 2007 15:55:14 +0300 (EEST)
From: Petko Manolov <petkan@nucleusys.com>
To: joe@perches.com
cc: torvalds@linux-foundation.org, petkan@users.sourceforge.net,
       netdev@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [504/2many] MAINTAINERS - USB PEGASUS DRIVER
In-Reply-To: <46bffc64.Are6NTp/45DX6lxZ%joe@perches.com>
Message-ID: <Pine.LNX.4.64.0708131553290.14743@bender.nucleusys.com>
References: <46bffc64.Are6NTp/45DX6lxZ%joe@perches.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007, joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d822865..fc87fa7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4764,6 +4764,7 @@ L:	linux-usb-devel@lists.sourceforge.net
> L:	netdev@vger.kernel.org
> W:	http://pegasus2.sourceforge.net/
> S:	Maintained
> +F:	drivers/net/usb/pegasus.*
>
> USB PRINTER DRIVER (usblp)
> P:	Pete Zaitcev
>

Well, what can i say?  "NO, don't do it!" is probably not going to work so 
i assume i will have to ACK.  :-)


 		Petko
