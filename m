Return-Path: <linux-kernel-owner+w=401wt.eu-S1762227AbZENCaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762227AbZENCaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 22:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760690AbZENC3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 22:29:53 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:54858 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbZENC3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 22:29:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=DINUx01vWTV4IqWAgD+FGj37doV9HFQWPnsj3Y6E4kBeSB936v67jUvEAOM8mjgUmu
         LRh7cBYemkf5xDxTgeCgL44mcXS6LJ9pY2eOmtBH8lXxDRog28qffTgp2BRUnbLb8+f4
         HZy8K1ruBhPGsYsXHbea6uova9G2zOA2TYRtk=
Date: Thu, 14 May 2009 11:29:39 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Andi Kleen <andi@firstfloor.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/2] remove CONFIG_UNEVICTABLE_LRU definition from
 defconfig
Message-Id: <20090514112939.ca23d021.minchan.kim@barrios-desktop>
In-Reply-To: <20090514111519.9B5D.A69D9226@jp.fujitsu.com>
References: <20090514110357.9B54.A69D9226@jp.fujitsu.com>
	<20090514111519.9B5D.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009 11:15:49 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Subject: [PATCH] remove CONFIG_UNEVICTABLE_LRU definition from defconfig
> 
> Now, There isn't CONFIG_UNEVICTABLE_LRU. these line are unnecessary.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Minchan Kim <minchan.kim@gmail.com>

Thanks for your lots or effort. :)

-- 
Kinds Regards
Minchan Kim
