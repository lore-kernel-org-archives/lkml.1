Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZEIIOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZEIIOG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 04:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZEIINq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 04:13:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55322 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbZEIINp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 04:13:45 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 6/8] pagemap: document 9 more exported page flags
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       Andi Kleen <andi@firstfloor.org>, <linux-mm@kvack.org>
In-Reply-To: <20090508111031.568178884@intel.com>
References: <20090508105320.316173813@intel.com> <20090508111031.568178884@intel.com>
Message-Id: <20090509171125.8D08.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Sat,  9 May 2009 17:13:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also add short descriptions for all of the 20 exported page flags.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  Documentation/vm/pagemap.txt |   62 +++++++++++++++++++++++++++++++++
>  1 file changed, 62 insertions(+)
> 
> --- linux.orig/Documentation/vm/pagemap.txt
> +++ linux/Documentation/vm/pagemap.txt
> @@ -49,6 +49,68 @@ There are three components to pagemap:
>       8. WRITEBACK
>       9. RECLAIM
>      10. BUDDY
> +    11. MMAP
> +    12. ANON
> +    13. SWAPCACHE
> +    14. SWAPBACKED
> +    15. COMPOUND_HEAD
> +    16. COMPOUND_TAIL
> +    16. HUGE

nit. 16 appear twice.



> +    18. UNEVICTABLE
> +    20. NOPAGE


