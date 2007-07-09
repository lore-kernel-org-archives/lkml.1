Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbXGIM1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbXGIM1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 08:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbXGIM1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 08:27:11 -0400
Received: from brick.kernel.dk ([80.160.20.94]:18720 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbXGIM1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 08:27:10 -0400
Date: Mon, 9 Jul 2007 14:27:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] unexport bio_{,un}map_user
Message-ID: <20070709122718.GX5267@kernel.dk>
References: <20070701202150.GN10869@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701202150.GN10869@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01 2007, Adrian Bunk wrote:
> bio_{,un}map_user no longer have any modular users.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Thanks, applied.

-- 
Jens Axboe

