Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbZHRMPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbZHRMPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758807AbZHRMPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:15:54 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50742 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZHRMPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:15:54 -0400
Date: Tue, 18 Aug 2009 14:15:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CFQ: get rid of must_alloc flag
Message-ID: <20090818121555.GO12579@kernel.dk>
References: <4A7B930D.6060206@cn.fujitsu.com> <4A8A3711.7020005@cn.fujitsu.com> <20090818083623.GL12579@kernel.dk> <4A8A717A.40106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8A717A.40106@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18 2009, Gui Jianfeng wrote:
> Jens Axboe wrote:
> > On Tue, Aug 18 2009, Gui Jianfeng wrote:
> >> Get rid of must_alloc flag since it's redundant now.
> > 
> > I already queued an identical patch in for-2.6.32 a week ago:
> > 
> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=87783e4b0213b6b000108f17e2cd91045bee56f7;hp=37571a15498816c1a35f1dd2b68f7ddac5c50592
> > 
> 
> Ahh.. see, sorry for bothering.

Don't apologize, thanks for noticing!

-- 
Jens Axboe

