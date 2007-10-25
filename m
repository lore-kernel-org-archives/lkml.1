Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbXJYJ0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbXJYJ0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 05:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbXJYJ0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 05:26:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:45631 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbXJYJ0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 05:26:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,328,1188802800"; 
   d="scan'208";a="357886156"
Subject: Re: [PATCH] iwl3945: cleanup namespace
From: Zhu Yi <yi.zhu@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071012130500.GA22610@lst.de>
References: <20071012130500.GA22610@lst.de>
Content-Type: text/plain
Organization: Intel Corp.
Date: Thu, 25 Oct 2007 17:19:57 +0800
Message-Id: <1193303997.3069.389.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-12 at 15:05 +0200, Christoph Hellwig wrote:
> prefix all symbols with iwl3945_ and thus allow building the driver
> into the kernel.  Also remove all the useless default statements in
> Kconfig while we're at it.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Did you do this manually or with a script? If it is the latter, can you
run it again against my latest updates for the driver (30 patches I just
sent to linux-wireless) or share the script with me?

Thanks,
-yi
