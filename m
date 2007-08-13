Return-Path: <linux-kernel-owner+w=401wt.eu-S946897AbXHMQN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946897AbXHMQN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947636AbXHMOyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:54:13 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:56101 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S944345AbXHMOyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:54:09 -0400
Date: Mon, 13 Aug 2007 09:54:06 -0500
From: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH] [264/2many] MAINTAINERS - IPMI SUBSYSTEM
In-reply-to: <46bffa75.qEmjEDgYnspaocFg%joe@perches.com>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, openipmi-developer@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Message-id: <46C0708E.1060903@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <46bffa75.qEmjEDgYnspaocFg%joe@perches.com>
User-Agent: Icedove 1.5.0.12 (X11/20070606)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

Acked-by: Corey Minyard <cminyard@mvista.com>

joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4157218..c1a9131 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2524,6 +2524,9 @@ M:	minyard@acm.org
>  L:	openipmi-developer@lists.sourceforge.net
>  W:	http://openipmi.sourceforge.net/
>  S:	Supported
> +F:	Documentation/IPMI.txt
> +F:	drivers/char/ipmi/
> +F:	include/linux/ipmi*
>  
>  IPX NETWORK LAYER
>  P:	Arnaldo Carvalho de Melo
>   

