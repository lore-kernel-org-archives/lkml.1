Return-Path: <linux-kernel-owner+w=401wt.eu-S1761120AbXGRJBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761120AbXGRJBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884AbXGRJBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:01:06 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:53478 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbXGRJBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:01:04 -0400
Date: Wed, 18 Jul 2007 09:35:35 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Joe Jin <joe.jin@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       bill.irwin@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
In-Reply-To: <20070718080927.GA28037@joejin-pc.cn.oracle.com>
Message-ID: <Pine.LNX.4.64.0707180935001.11116@blonde.wat.veritas.com>
References: <20070712221842.f5e47065.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707171558470.26771@blonde.wat.veritas.com>
 <20070717093228.3a3638aa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707171818080.19489@blonde.wat.veritas.com>
 <20070717115849.9f5e435c.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707172044001.5286@blonde.wat.veritas.com>
 <20070717130118.bc78d31a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707172133400.9010@blonde.wat.veritas.com>
 <20070718014027.GA23559@joejin-pc.cn.oracle.com>
 <Pine.LNX.4.64.0707180521470.18593@blonde.wat.veritas.com>
 <20070718080927.GA28037@joejin-pc.cn.oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABWluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAb2xlZ0B0di1zaWduLnJ1AGJpbGwuaXJ3aW5Ab3JhY2xlLmNvbQBqb2UuamluQG9yYWNsZS5jb20AYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, Joe Jin wrote:

> Sorry for I use a unclean kernel tree, the panic have gone ;)
> also, I will testing it again with other server, if I hit it I'll let you know.

That's a relief!  Thanks,
Hugh
