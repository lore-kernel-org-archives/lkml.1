Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbXJWSpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbXJWSpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbXJWSoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:44:54 -0400
Received: from brick.kernel.dk ([87.55.233.238]:8389 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbXJWSox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:44:53 -0400
Date: Tue, 23 Oct 2007 20:44:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Dale Farnsworth <dale@farnsworth.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Fix fallout from sg_page changes
Message-ID: <20071023184448.GE14671@kernel.dk>
References: <20071023145300.GA18989@xyzzy.farnsworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023145300.GA18989@xyzzy.farnsworth.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Dale Farnsworth wrote:
> 
> Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
> ---
>  include/asm-powerpc/dma-mapping.h |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)

Should already be merged in Linus' current tree.

-- 
Jens Axboe

