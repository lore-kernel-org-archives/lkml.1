Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab0BKFW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 00:22:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:57172 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab0BKFW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 00:22:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,449,1262592000"; 
   d="scan'208";a="539766076"
Date: Thu, 11 Feb 2010 13:22:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Remove unused macro, VM_MIN_READAHEAD.
Message-ID: <20100211052247.GA15392@localhost>
References: <201002091659.19988.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002091659.19988.knikanth@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikanth,

On Tue, Feb 09, 2010 at 04:59:19PM +0530, Nikanth Karthikesan wrote:
> Remove unused macro, VM_MIN_READAHEAD.

NAK, sorry.

I'm using VM_MIN_READAHEAD in this patchset:

        http://lkml.org/lkml/2010/2/2/232

So please don't drop it.

Thanks,
Fengguang
