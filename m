Return-Path: <linux-kernel-owner+w=401wt.eu-S1758286AbXGaXO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286AbXGaXO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbXGaXOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:14:49 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28292 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbXGaXOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:14:48 -0400
In-Reply-To: <1185920712.31134.21.camel@dyn9047017100.beaverton.ibm.com>
References: <20070727071547.GA25084@joejin-pc.cn.oracle.com> <46A9E6F9.20603@oracle.com> <20070728034719.GA24448@joejin-pc.cn.oracle.com> <20070730135316.2ce21b28.akpm@linux-foundation.org> <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com> <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com> <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com> <05506FB8-1164-4E62-8C02-3AC3681E7D89@oracle.com> <20070731005348.GA8308@joejin-pc.cn.oracle.com> <46AEB055.9050607@us.ibm.com> <20070731043554.GA3393@joejin-pc.cn.oracle.com> <1185920712.31134.21.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <F15EF023-2FC0-4FCB-9319-14D5DD0DD456@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
       gurudas pai <gurudas.pai@oracle.com>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, lkml <linux-kernel@vger.kernel.org>,
       wen.gang.wang@oracle.com
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] add check do_direct_IO() return val
Date: Tue, 31 Jul 2007 16:14:31 -0700
To: Badari Pulavarty <pbadari@us.ibm.com>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Okay. Here is the fix for the problem.

Yeah, that looks right from my understanding too.  Thanks, Badari.

> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>

  Acked-by: Zach Brown <zach.brown@oracle.com>

- z
