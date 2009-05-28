Return-Path: <linux-kernel-owner+w=401wt.eu-S1762413AbZE1Ihp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762413AbZE1Ihp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762060AbZE1IhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:37:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44604 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761329AbZE1IhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:37:16 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] remove CONFIG_UNEVICTABLE_LRU definition from defconfig
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
       Andi Kleen <andi@firstfloor.org>, Minchan Kim <minchan.kim@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>, Matt Mackall <mpm@selenic.com>
In-Reply-To: <20090528013146.6dd99aa0.akpm@linux-foundation.org>
References: <20090514111519.9B5D.A69D9226@jp.fujitsu.com> <20090528013146.6dd99aa0.akpm@linux-foundation.org>
Message-Id: <20090528173242.92E4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 28 May 2009 17:37:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 14 May 2009 11:15:49 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Subject: [PATCH] remove CONFIG_UNEVICTABLE_LRU definition from defconfig
> > 
> > Now, There isn't CONFIG_UNEVICTABLE_LRU. these line are unnecessary.
> > 
> > ...
> >
> >  196 files changed, 196 deletions(-)
> 
> Gad.
> 
> I don't know if this is worth bothering about really.  The dead Kconfig
> option will slowly die a natural death as people refresh the defconfig
> files.

ok. I'll drop this patch. 
Sorry, I did not have the experience that changed defconfig ;)



