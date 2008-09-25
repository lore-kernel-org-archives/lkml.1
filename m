Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYIYFry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYIYFry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 01:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYIYFrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 01:47:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:26195 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbYIYFrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 01:47:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,306,1220252400"; 
   d="scan'208";a="51150526"
Subject: Re: pull request: wireless-2.6 2008-09-24
From: Zhu Yi <yi.zhu@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080924231720.GD3639@tuxdriver.com>
References: <20080924231720.GD3639@tuxdriver.com>
Content-Type: text/plain
Organization: Intel Corp.
Date: Thu, 25 Sep 2008 13:47:02 +0800
Message-Id: <1222321622.2510.455.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 17:17 -0600, John W. Linville wrote:
> Dave,
> 
> One more for 2.6.27 -- a fix for a possible interrupt storm.  There is
> even a link in the commit log to a youtube video of the storm in
> progress. :-)
> 
> Let me know if there are problems!

Can you also add this one? It doesn't panic the kernel when a frame from
firmware is invalid.

http://marc.info/?l=linux-wireless&m=122219037706528&w=2

Thanks,
-yi

