Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYHDJ5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYHDJ5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 05:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYHDJ5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 05:57:37 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26074 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbYHDJ5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 05:57:37 -0400
Date: Mon, 4 Aug 2008 11:57:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Denis ChengRq <crquan@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bio: make use of bvec_nr_vecs
Message-ID: <20080804095735.GB20055@kernel.dk>
References: <1217009473-25878-1-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217009473-25878-1-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26 2008, Denis ChengRq wrote:
> Since introduced in 7ba1ba12eee, it should be made use of.
> 
> Signed-off-by: Denis ChengRq <crquan@gmail.com>

Thanks, applied.

> Additionally, I think it maybe better if inlined in <linux/bio.h>

Submit a patch :-)

-- 
Jens Axboe

