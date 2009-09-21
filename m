Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZIUTL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZIUTL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 15:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbZIUTLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 15:11:25 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46296 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbZIUTLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 15:11:25 -0400
Date: Mon, 21 Sep 2009 21:11:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Add a tracepoint for block request remapping
Message-ID: <20090921191128.GF23126@kernel.dk>
References: <4AB7A8EE.9070607@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB7A8EE.9070607@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22 2009, Jun'ichi Nomura wrote:
> # Re-sending just the core bit.
> 
> Since 2.6.31 now has request-based device-mapper, it's useful to have
> a tracepoint for request-remapping as well as bio-remapping.
> This patch adds a tracepoint for request-remapping, trace_block_rq_remap().

Applied to the upstream for-linus branch (for 2.6.32).

-- 
Jens Axboe

