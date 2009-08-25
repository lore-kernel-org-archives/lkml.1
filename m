Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbZHYBHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbZHYBHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 21:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZHYBHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 21:07:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:7895 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbZHYBHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 21:07:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,268,1249282800"; 
   d="scan'208";a="544419108"
Date: Mon, 24 Aug 2009 18:07:43 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
       Dave Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH] PCI/vgaarb: cleanup some warnings + cleanup some
 comments.
Message-ID: <20090824180743.47cf9fa6@jbarnes-g45>
In-Reply-To: <1250659317-28062-1-git-send-email-airlied@gmail.com>
References: <1250659317-28062-1-git-send-email-airlied@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 15:21:57 +1000
Dave Airlie <airlied@gmail.com> wrote:

> From: Dave Airlie <airlied@linux.ie>
> 
> Fix some warnings reported in linux-next + also cleanup some
> comment errors noticed by Pekka Paalanen.
> 
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---
>  drivers/gpu/vga/vgaarb.c |   11 ++++-----
>  include/linux/vgaarb.h   |   49
> +++++++++++++++++++++++++-------------------- 2 files changed, 32
> insertions(+), 28 deletions(-)

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
