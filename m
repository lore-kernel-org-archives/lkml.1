Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbYHSSLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbYHSSLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbYHSSKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:10:42 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26420 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbYHSSKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:10:41 -0400
Date: Tue, 19 Aug 2008 20:10:37 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] block: add more + fix some block kernel-doc
Message-ID: <20080819181036.GI20055@kernel.dk>
References: <20080817214405.fa1b9eef.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080817214405.fa1b9eef.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17 2008, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add some block/ source files to the kernel-api docbook.
> Fix kernel-doc notation in them as needed.
> Fix changed function parameter names.
> Fix typos/spellos.
> In comments, change REQ_SPECIAL to REQ_TYPE_SPECIAL and
> REQ_BLOCK_PC to REQ_TYPE_BLOCK_PC.

Thanks Randy, applied!

-- 
Jens Axboe

