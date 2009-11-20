Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbZKTBxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbZKTBxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 20:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758039AbZKTBxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 20:53:15 -0500
Received: from mga03.intel.com ([143.182.124.21]:36244 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757731AbZKTBxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 20:53:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,774,1249282800"; 
   d="scan'208";a="213676172"
Date: Fri, 20 Nov 2009 09:53:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/12] writeback: remove unused nonblocking and
	congestion checks (pohmelfs)
Message-ID: <20091120015317.GB6028@localhost>
References: <20091118082648.140755818@intel.com> <20091118082845.828021716@intel.com> <20091119081154.GE5922@localhost> <20091119110413.GA20188@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119110413.GA20188@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

On Thu, Nov 19, 2009 at 07:04:13PM +0800, Evgeniy Polyakov wrote:
> H1.
> 
> On Thu, Nov 19, 2009 at 04:11:54PM +0800, Wu Fengguang (fengguang.wu@intel.com) wrote:
> > Will you pick up this updated patch? It also removes the unused bdi.
> 
> I'm ok with the changes, but I suppose it should be pushed as a single
> patchet into the tree, no?

Either way works. I would submit a single patchset that includes the
generic ones and the fs specific patches that have not been picked up
into their fs tree :)

Thanks,
Fengguang

