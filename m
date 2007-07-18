Return-Path: <linux-kernel-owner+w=401wt.eu-S1759777AbXGRILr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777AbXGRILr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 04:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbXGRILd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 04:11:33 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:15514 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbXGRILb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 04:11:31 -0400
Date: Wed, 18 Jul 2007 16:09:27 +0800
From: Joe Jin <joe.jin@oracle.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Joe Jin <joe.jin@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-ID: <20070718080927.GA28037@joejin-pc.cn.oracle.com>
References: <20070712221842.f5e47065.akpm@linux-foundation.org> <Pine.LNX.4.64.0707171558470.26771@blonde.wat.veritas.com> <20070717093228.3a3638aa.akpm@linux-foundation.org> <Pine.LNX.4.64.0707171818080.19489@blonde.wat.veritas.com> <20070717115849.9f5e435c.akpm@linux-foundation.org> <Pine.LNX.4.64.0707172044001.5286@blonde.wat.veritas.com> <20070717130118.bc78d31a.akpm@linux-foundation.org> <Pine.LNX.4.64.0707172133400.9010@blonde.wat.veritas.com> <20070718014027.GA23559@joejin-pc.cn.oracle.com> <Pine.LNX.4.64.0707180521470.18593@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707180521470.18593@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for I use a unclean kernel tree, the panic have gone ;)
also, I will testing it again with other server, if I hit it I'll let you know.

Thanks,
Joe
