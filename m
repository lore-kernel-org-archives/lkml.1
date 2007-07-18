Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbXGRHhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbXGRHhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbXGRHhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:37:31 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45309 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbXGRHha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:37:30 -0400
Date: Wed, 18 Jul 2007 15:34:28 +0800
From: Joe Jin <joe.jin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Joe Jin <joe.jin@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-ID: <20070718073428.GB27366@joejin-pc.cn.oracle.com>
References: <Pine.LNX.4.64.0707171558470.26771@blonde.wat.veritas.com> <20070717093228.3a3638aa.akpm@linux-foundation.org> <Pine.LNX.4.64.0707171818080.19489@blonde.wat.veritas.com> <20070717115849.9f5e435c.akpm@linux-foundation.org> <Pine.LNX.4.64.0707172044001.5286@blonde.wat.veritas.com> <20070717130118.bc78d31a.akpm@linux-foundation.org> <Pine.LNX.4.64.0707172133400.9010@blonde.wat.veritas.com> <20070718014027.GA23559@joejin-pc.cn.oracle.com> <Pine.LNX.4.64.0707180521470.18593@blonde.wat.veritas.com> <20070717224515.869f7040.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717224515.869f7040.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > That is... surprising to me.
> 
> To me also.  I'd like to double-check the code which Joe actually
> tested, please - have a sneaking suspicion that the 2.6.22 version
> of that function was tested ;)

Maybe I make a fault? I'll testing it again then give you a report.

Thank,
Joe
