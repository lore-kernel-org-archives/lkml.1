Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbXLLBES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbXLLBES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 20:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXLLBEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 20:04:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:58754 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbXLLBEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 20:04:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,154,1196668800"; 
   d="scan'208";a="433443968"
Subject: Re: [2.6 patch] wireless/ipw2200.c: add __dev{init,exit}
	annotations
From: Zhu Yi <yi.zhu@intel.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: jketreno@linux.intel.com, linux-wireless@vger.kernel.org,
       ipw2100-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20071211222022.GC14204@stusta.de>
References: <20071211222022.GC14204@stusta.de>
Content-Type: text/plain
Organization: Intel Corp.
Date: Wed, 12 Dec 2007 09:02:19 +0800
Message-Id: <1197421340.3170.400.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-11 at 23:20 +0100, Adrian Bunk wrote:
> This patch adds __dev{init,exit} annotations.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

ACK.

Thanks,
-yi
