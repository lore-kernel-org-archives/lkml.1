Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab0BKPRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 10:17:04 -0500
Received: from mga03.intel.com ([143.182.124.21]:36472 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756265Ab0BKPRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 10:17:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,453,1262592000"; 
   d="scan'208";a="243004012"
Date: Thu, 11 Feb 2010 23:16:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Ankit Jain <radical@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] Make VM_MAX_READAHEAD a kernel parameter
Message-ID: <20100211151651.GA8753@localhost>
References: <201002091659.27037.knikanth@suse.de> <201002111546.35036.knikanth@suse.de> <d24465cb1002110315x4af18888na55aa8d61478e094@mail.gmail.com> <201002111715.04411.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002111715.04411.knikanth@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikanth,

> From: Nikanth Karthikesan <knikanth@suse.de>
> 
> Add new kernel parameter "readahead", which would be used instead of the
> value of VM_MAX_READAHEAD. If the parameter is not specified, the default
> of 128kb would be used.

The patch looks good to me, though it conflicts with my patches.
Do you mind me including a modified version in my readahead patchset?

Thanks,
Fengguang
