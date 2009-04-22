Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZDVNQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZDVNQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZDVNQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:16:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49865 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610AbZDVNQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:16:04 -0400
Date: Wed, 22 Apr 2009 15:16:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Wolfram Strepp <wstrepp@gmx.de>
Subject: Re: [BUG] rbtree bug with mmotm 2009-04-14-17-24
Message-ID: <20090422131602.GN4593@kernel.dk>
References: <20090421184223.GP19637@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421184223.GP19637@balbir.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22 2009, Balbir Singh wrote:
> Hi, Andrew,
> 
> I did a quick check on lkml to see if someone reported this issue
> already, I could not find any reports. I am beginning to see several
> of these on my machine. I saw recent refactoring of rbtrees, I've
> cc'ed Wolfram Strepp.

This has already been fixed and the code in question is also in mainline
at this point. So it looks like mmotm is just somewhat out of date.

-- 
Jens Axboe

