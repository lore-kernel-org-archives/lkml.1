Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbXLJDND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbXLJDND (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 22:13:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbXLJDMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 22:12:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:58124 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbXLJDMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 22:12:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,274,1194249600"; 
   d="scan'208";a="428795434"
Subject: Re: [PATCH] iwlwifi3945/4965 - fix rate control algo reference leak
From: Zhu Yi <yi.zhu@intel.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       "John W.Linville" <linville@tuxdriver.com>,
       Thomas Tuttle <linux-kernel@ttuttle.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Wu <flamingice@sourmilk.net>,
       LWML <linux-wireless@vger.kernel.org>
In-Reply-To: <475AB087.5050209@rtr.ca>
References: <20071206093922.GA7356@cvg>
	 <1196991573.3170.43.camel@debian.sh.intel.com>  <475AB087.5050209@rtr.ca>
Content-Type: text/plain
Organization: Intel Corp.
Date: Mon, 10 Dec 2007 11:04:56 +0800
Message-Id: <1197255896.3170.232.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-08 at 09:56 -0500, Mark Lord wrote:
> 
> Any chance of getting LEDs support re-added to this driver,
> perhaps in the 2.6.25 timeframe?

I'd also like to see it happen. Stay tuned.

Thanks,
-yi
