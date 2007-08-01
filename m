Return-Path: <linux-kernel-owner+w=401wt.eu-S1764367AbXHABhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764367AbXHABhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbXHABh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:37:26 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:21362 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbXHABh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:37:26 -0400
Date: Wed, 1 Aug 2007 09:36:32 +0800
From: Joe Jin <joe.jin@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Joe Jin <joe.jin@oracle.com>,
       Zach Brown <zach.brown@oracle.com>,
       gurudas pai <gurudas.pai@oracle.com>, jens.axboe@oracle.com,
       lkml <linux-kernel@vger.kernel.org>, wen.gang.wang@oracle.com
Subject: Re: [PATCH] add check do_direct_IO() return val
Message-ID: <20070801013632.GB10449@joejin-pc.cn.oracle.com>
References: <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com> <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com> <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com> <05506FB8-1164-4E62-8C02-3AC3681E7D89@oracle.com> <20070731005348.GA8308@joejin-pc.cn.oracle.com> <46AEB055.9050607@us.ibm.com> <20070731043554.GA3393@joejin-pc.cn.oracle.com> <1185920712.31134.21.camel@dyn9047017100.beaverton.ibm.com> <20070731153410.fcbf9a1b.akpm@linux-foundation.org> <alpine.LFD.0.999.0707311555410.4161@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707311555410.4161@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Does a patch like this work? I don't have any test-cases, but it would be 
> good to have something like this tested and passed back with proper 
> explanations and sign-offs.

Yes it work find after apply the patch, thanks.

Joe
