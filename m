Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbYJIIpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbYJIIpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 04:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYJIIpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 04:45:32 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:41672 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbYJIIpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 04:45:31 -0400
Date: Thu, 9 Oct 2008 10:44:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>,
       andrew.patterson@hp.com
Subject: Re: [PATCH -mm/git] block_dev: fix kernel-doc in new functions
Message-ID: <20081009084458.GC19428@kernel.dk>
References: <48ED0233.3040603@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ED0233.3040603@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08 2008, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kernel-doc in new functions:
> 
> Error(mmotm-2008-1002-1617//fs/block_dev.c:895): duplicate section name 'Description'
> Error(mmotm-2008-1002-1617//fs/block_dev.c:924): duplicate section name 'Description'
> Warning(mmotm-2008-1002-1617//fs/block_dev.c:1282): No description found for parameter 'pathname'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Andrew Patterson <andrew.patterson@hp.com>

Thanks Randy, applied.

-- 
Jens Axboe

