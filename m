Return-Path: <linux-kernel-owner+w=401wt.eu-S1762378AbXJQHlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762378AbXJQHlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 03:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbXJQHlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 03:41:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:56336 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbXJQHlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 03:41:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,288,1188802800"; 
   d="scan'208";a="348459659"
Subject: Re: [2.6 patch] iwl4965-base.c: fix off-by-one errors
From: Zhu Yi <yi.zhu@intel.com>
To: Adrian Bunk <bunk@kernel.org>, "John W.Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071014175115.GL4211@stusta.de>
References: <20071014175115.GL4211@stusta.de>
Content-Type: text/plain
Organization: Intel Corp.
Date: Wed, 17 Oct 2007 15:33:52 +0800
Message-Id: <1192606433.2992.20.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-10-14 at 19:51 +0200, Adrian Bunk wrote:
> This patch fixes two off-by-one errors resulting in array overflows 
> spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

ACK.

John, please apply.

Thanks,
-yi
