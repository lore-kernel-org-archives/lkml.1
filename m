Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbXGUR7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbXGUR7K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 13:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbXGUR66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 13:58:58 -0400
Received: from brick.kernel.dk ([80.160.20.94]:2199 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbXGUR65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 13:58:57 -0400
Date: Sat, 21 Jul 2007 19:58:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Boutcher <boutcher@us.ibm.com>, Ryan Arnold <ryanarn@us.ibm.com>,
       Colin Devilbiss <devilbis@us.ibm.com>,
       Stephen Rothwell <sfr@au1.ibm.com>
Subject: Re: [PATCH][05/37] Clean up duplicate includes in drivers/block/
Message-ID: <20070721175856.GO11657@kernel.dk>
References: <200707211701.53199.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707211701.53199.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21 2007, Jesper Juhl wrote:
> Hi,
> 
> This patch cleans up duplicate includes in
> 	drivers/block/
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

