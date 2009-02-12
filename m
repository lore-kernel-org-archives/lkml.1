Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbZBLAEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbZBLAEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 19:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZBLAD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 19:03:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:28092 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbZBLAD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 19:03:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,194,1233561600"; 
   d="scan'208";a="489274532"
Message-ID: <4993676A.8030009@intel.com>
Date: Wed, 11 Feb 2009 17:03:54 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Johannes Weiner <jw@emlix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch][trivial] dmaengine: update kerneldoc
References: <E1LXHIv-00021Q-Vm@mailer.emlix.com>
In-Reply-To: <E1LXHIv-00021Q-Vm@mailer.emlix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> Some of the kerneldoc comments in the dmaengine header describe
> already removed structure members.  Remove them.
> 
> Also add a short description for dma_device->device_is_tx_complete.
> 
> Signed-off-by: Johannes Weiner <jw@emlix.com>

Thanks, applied.

--
Dan
