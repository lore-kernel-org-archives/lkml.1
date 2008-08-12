Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbYHLBVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbYHLBVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 21:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbYHLBV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 21:21:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:5395 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbYHLBV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 21:21:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,192,1217833200"; 
   d="scan'208";a="325390361"
Subject: Re: [PATCH 1/1] iwlwifi: fix printk newlines
From: Zhu Yi <yi.zhu@intel.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1218491381-1313-1-git-send-email-jirislaby@gmail.com>
References: <1218491381-1313-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain
Organization: Intel Corp.
Date: Tue, 12 Aug 2008 09:20:35 +0800
Message-Id: <1218504035.3107.198.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-11 at 23:49 +0200, Jiri Slaby wrote:
> Add newlines at printk outputs to not break dmesg.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Zhu Yi <yi.zhu@intel.com>
> Cc: Reinette Chatre <reinette.chatre@intel.com>
> Cc: John W. Linville <linville@tuxdriver.com>

Ack.

Thanks,
-yi

