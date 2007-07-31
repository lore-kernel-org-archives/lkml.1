Return-Path: <linux-kernel-owner+w=401wt.eu-S1759390AbXGaXQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbXGaXQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbXGaXQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:16:30 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28874 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbXGaXQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:16:29 -0400
In-Reply-To: <alpine.LFD.0.999.0707311555410.4161@woody.linux-foundation.org>
References: <20070727071547.GA25084@joejin-pc.cn.oracle.com> <46A9E6F9.20603@oracle.com> <20070728034719.GA24448@joejin-pc.cn.oracle.com> <20070730135316.2ce21b28.akpm@linux-foundation.org> <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com> <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com> <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com> <05506FB8-1164-4E62-8C02-3AC3681E7D89@oracle.com> <20070731005348.GA8308@joejin-pc.cn.oracle.com> <46AEB055.9050607@us.ibm.com> <20070731043554.GA3393@joejin-pc.cn.oracle.com> <1185920712.31134.21.camel@dyn9047017100.beaverton.ibm.com> <20070731153410.fcbf9a1b.akpm@linux-foundation.org> <alpine.LFD.0.999.0707311555410.4161@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <EFEB0F53-5108-4092-9FBF-5E968C447723@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Joe Jin <joe.jin@oracle.com>,
       gurudas pai <gurudas.pai@oracle.com>, jens.axboe@oracle.com,
       lkml <linux-kernel@vger.kernel.org>, wen.gang.wang@oracle.com
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] add check do_direct_IO() return val
Date: Tue, 31 Jul 2007 16:16:09 -0700
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Does a patch like this work? I don't have any test-cases, but it  
> would be
> good to have something like this tested and passed back with proper
> explanations and sign-offs.

It should, yeah.

I'm bringing up a more capable IO testbed over here.  I'll run it  
through the tests I have once that setup.  I wouldn't cry if someone  
beat me to it ;).

- z
