Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbYKPSqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbYKPSqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbYKPSnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:43:14 -0500
Received: from fgwnews.fujitsu.co.jp ([164.71.1.134]:55266 "EHLO
	fgwnews.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbYKPSnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:43:12 -0500
Date: Mon, 17 Nov 2008 03:42:33 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
Cc: kosaki.motohiro@jp.fujitsu.com, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "David S. Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20081116044901.GA24624@x200.localdomain>
References: <491FA28B.2070003@cn.fujitsu.com> <20081116044901.GA24624@x200.localdomain>
Message-Id: <20081117033203.F20E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > this patch introduces simple_malloc() and simple_free().
> 
> Grossly misnamed. It should be kvmalloc/kvfree, at least.

I also like the name of kvmalloc because "simple_" prefix seems too ambiguity.

Otherthings, looks good to me.
this patch is just cleanup. it definitly don't have any side effect.

So, I think vmalloc disadvantage discussion isn't point so much.
There alaredy is.


