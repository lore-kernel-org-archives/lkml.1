Return-Path: <linux-kernel-owner+w=401wt.eu-S1765836AbZFLNea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765836AbZFLNea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764865AbZFLN1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:27:16 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36132 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764839AbZFLN1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:27:15 -0400
Date: Fri, 12 Jun 2009 15:27:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq: cleanup for last_end_request in cfq_data
Message-ID: <20090612132717.GI11363@kernel.dk>
References: <4A31C4B9.9090009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A31C4B9.9090009@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12 2009, Gui Jianfeng wrote:
> Hi Jens,
> 
> Actually, last_end_request in cfq_data isn't used now.

Thanks, applied!

-- 
Jens Axboe

