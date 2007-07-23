Return-Path: <linux-kernel-owner+w=401wt.eu-S1761444AbXGWG3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761444AbXGWG3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbXGWG3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:29:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43339 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbXGWG3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:29:47 -0400
Date: Mon, 23 Jul 2007 15:28:56 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH][22/37] Clean up duplicate includes in include/linux/memory_hotplug.h
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>
In-Reply-To: <200707211703.27367.jesper.juhl@gmail.com>
References: <200707211703.27367.jesper.juhl@gmail.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070723151013.35E6.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Oops. This should be.... 
Thanks!

Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>


> Hi,
> 
> This patch cleans up duplicate includes in
> 	include/linux/memory_hotplug.h
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 7b54666..b573d1e 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -3,7 +3,6 @@
>  
>  #include <linux/mmzone.h>
>  #include <linux/spinlock.h>
> -#include <linux/mmzone.h>
>  #include <linux/notifier.h>
>  
>  struct page;

-- 
Yasunori Goto 


