Return-Path: <linux-kernel-owner+w=401wt.eu-S939961AbXG3VKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939961AbXG3VKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939274AbXG3VKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:10:47 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:25872 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764294AbXG3VKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:10:46 -0400
In-Reply-To: <20070730135316.2ce21b28.akpm@linux-foundation.org>
References: <20070726090400.GA18640@joejin-pc.cn.oracle.com> <20070726221307.3d7b3446.akpm@linux-foundation.org> <20070727071547.GA25084@joejin-pc.cn.oracle.com> <46A9E6F9.20603@oracle.com> <20070728034719.GA24448@joejin-pc.cn.oracle.com> <20070730135316.2ce21b28.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B296E94F-E42A-4542-A43D-1C90523DE4C2@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>, gurudas pai <gurudas.pai@oracle.com>,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, wen.gang.wang@oracle.com,
       Badari Pulavarty <pbadari@us.ibm.com>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] add check do_direct_IO() return val
Date: Mon, 30 Jul 2007 14:09:37 -0700
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> fyi, I dropped the earlier patch and now we have nothing.  Please  
> let's get all
> this sorted out in time for 2.6.23.  Which is still many weeks away  
> so there is
> plenty of time to prepare something which was carefully reviewed  
> and well-tested,
> thanks.

I was distracted by OSCON last week.  I'm working on reproducing this  
and wrapping my head around it as we speak.  We'll get it sorted out.

- z
