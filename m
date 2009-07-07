Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbZGGOYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbZGGOYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbZGGOYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:24:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:9200 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757593AbZGGOYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:24:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,363,1243839600"; 
   d="scan'208";a="472637003"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "haavard.skinnemoen@atmel.com" <haavard.skinnemoen@atmel.com>,
       "patrice.vilchez@atmel.com" <patrice.vilchez@atmel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 7 Jul 2009 15:24:42 +0100
Subject: RE: [PATCH] dmaengine: dmatest: correct thread_count while using
 multiple thread per channel
Thread-Topic: [PATCH] dmaengine: dmatest: correct thread_count while using
 multiple thread per channel
Thread-Index: Acn+TQ7WRibkFxKrSqmS4X1xM1BbFgAwTSGw
Message-ID: <129600E5E5FB004392DDC3FB599660D7AF5BB022@irsmsx504.ger.corp.intel.com>
References: <1246897184-16833-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1246897184-16833-1-git-send-email-nicolas.ferre@atmel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre wrote:
> It seems that thread_count is not properly calculated in dmatest.
> In fact the thread count number that is returned from dmatest_add_threads() is
> not correctly added to the thread_count and thus not properly printed.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>