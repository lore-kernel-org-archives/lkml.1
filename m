Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbZGGOYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbZGGOYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbZGGOYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:24:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:63284 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761AbZGGOYf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:24:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,363,1243839600"; 
   d="scan'208";a="705669893"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
       "avictor.za@gmail.com" <avictor.za@gmail.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "haavard.skinnemoen@atmel.com" <haavard.skinnemoen@atmel.com>,
       "patrice.vilchez@atmel.com" <patrice.vilchez@atmel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 7 Jul 2009 15:24:34 +0100
Subject: RE: [PATCH] dmaengine: dmatest: add a maximum number of test
 iterations
Thread-Topic: [PATCH] dmaengine: dmatest: add a maximum number of test
 iterations
Thread-Index: Acn7+t2G9a+GzPzbRTG/48VanIX+FQDEz8nw
Message-ID: <129600E5E5FB004392DDC3FB599660D7AF5BB021@irsmsx504.ger.corp.intel.com>
References: <448c4e65b62b87188ff0beb21133b60435b1f6bd.1246641180.git.nicolas.ferre@atmel.com>
In-Reply-To: <448c4e65b62b87188ff0beb21133b60435b1f6bd.1246641180.git.nicolas.ferre@atmel.com>
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
> The dmatest usually waits for the killing of its kthreads to stop
> running tests.  This patch adds a parameter that sets a maximum
> number of test iterations.
> 
> This feature is quite interesting for debugging when you set a lot of
> traces in your dmaengine controller driver.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>