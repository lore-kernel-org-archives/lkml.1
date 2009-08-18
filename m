Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbZHRJTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbZHRJTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 05:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbZHRJS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 05:18:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60209 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbZHRJS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 05:18:59 -0400
Message-ID: <4A8A717A.40106@cn.fujitsu.com>
Date: Tue, 18 Aug 2009 17:16:42 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CFQ: get rid of must_alloc flag
References: <4A7B930D.6060206@cn.fujitsu.com> <4A8A3711.7020005@cn.fujitsu.com> <20090818083623.GL12579@kernel.dk>
In-Reply-To: <20090818083623.GL12579@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Aug 18 2009, Gui Jianfeng wrote:
>> Get rid of must_alloc flag since it's redundant now.
> 
> I already queued an identical patch in for-2.6.32 a week ago:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=87783e4b0213b6b000108f17e2cd91045bee56f7;hp=37571a15498816c1a35f1dd2b68f7ddac5c50592
> 

Ahh.. see, sorry for bothering.

-- 
Regards
Gui Jianfeng

