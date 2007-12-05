Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbXLEKSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbXLEKSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbXLEKSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:18:25 -0500
Received: from brick.kernel.dk ([87.55.233.238]:23864 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbXLEKSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:18:24 -0500
Date: Wed, 5 Dec 2007 11:16:06 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Aaron Carroll <aaronc@gelato.unsw.edu.au>, linux-kernel@vger.kernel.org,
       Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: [PATCH] as-iosched: fix incorrect comments
Message-ID: <20071205101606.GC4969@kernel.dk>
References: <4756783A.5020204@gelato.unsw.edu.au> <20071205101155.GD1114@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205101155.GD1114@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05 2007, Nick Piggin wrote:
> On Wed, Dec 05, 2007 at 09:06:50PM +1100, Aaron Carroll wrote:
> > Two comments refer to deadlines applying to reads only.  This is
> > not the case.
> > 
> > Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>
> 
> Acked-by: Nick Piggin <npiggin@suse.de>

Goodie, I'll apply this one as well.

-- 
Jens Axboe

