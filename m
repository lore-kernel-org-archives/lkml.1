Return-Path: <linux-kernel-owner+w=401wt.eu-S1762975AbXHABLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762975AbXHABLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbXHABLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:11:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:17517 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbXHABLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:11:41 -0400
Date: Wed, 1 Aug 2007 09:11:05 +0800
From: Joe Jin <joe.jin@oracle.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Joe Jin <joe.jin@oracle.com>, Zach Brown <zach.brown@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       gurudas pai <gurudas.pai@oracle.com>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, lkml <linux-kernel@vger.kernel.org>,
       wen.gang.wang@oracle.com
Subject: Re: [PATCH] add check do_direct_IO() return val
Message-ID: <20070801011105.GA10449@joejin-pc.cn.oracle.com>
References: <20070728034719.GA24448@joejin-pc.cn.oracle.com> <20070730135316.2ce21b28.akpm@linux-foundation.org> <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com> <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com> <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com> <05506FB8-1164-4E62-8C02-3AC3681E7D89@oracle.com> <20070731005348.GA8308@joejin-pc.cn.oracle.com> <46AEB055.9050607@us.ibm.com> <20070731043554.GA3393@joejin-pc.cn.oracle.com> <1185920712.31134.21.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185920712.31134.21.camel@dyn9047017100.beaverton.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Okay. Here is the fix for the problem.

It work fine, thanks.

> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
  
  Acked-by:  Joe Jin <joe.jin@oracle.com>
