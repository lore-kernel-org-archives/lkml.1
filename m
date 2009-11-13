Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbZKMHU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbZKMHU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 02:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbZKMHUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 02:20:22 -0500
Received: from [95.166.99.235] ([95.166.99.235]:52998 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbZKMHUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 02:20:21 -0500
Date: Fri, 13 Nov 2009 08:20:26 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Akira Tsukamoto <akirat@rd.scei.sony.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Jim Paris <jim@jtan.com>
Subject: Re: [PATCH] block/ps3: Fix slow VRAM IO
Message-ID: <20091113072025.GP8742@kernel.dk>
References: <20091103002322.1f04adbe.akpm@linux-foundation.org> <20091109154036.08C0.4D252088@rd.scei.sony.co.jp> <20091113110313.50BB.4D252088@rd.scei.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113110313.50BB.4D252088@rd.scei.sony.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13 2009, Akira Tsukamoto wrote:
> Hello Andrew Morton,
> 
> Ping?
> 
> This patch is pretty important to improve the performance of PS3.
> I really appreciate for your reply.

I queued it up for 2.6.33 some time ago, so it's not lost.

-- 
Jens Axboe

