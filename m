Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbYJVOz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbYJVOz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbYJVOzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:55:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:18795 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbYJVOzL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:55:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,464,1220252400"; 
   d="scan'208";a="394804010"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller
Date: Wed, 22 Oct 2008 15:55:07 +0100
Message-ID: <7F38996F7185A24AB9071ED4950AD8C1022288C6@swsmsx413.ger.corp.intel.com>
In-Reply-To: <48F8B291.1060500@atmel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller
Thread-Index: AckwbxwNmSQ3q26ATJ2JLuTtMazg1AD5l9eA
References: <48F8B291.1060500@atmel.com>
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Nicolas Ferre" <nicolas.ferre@atmel.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <linux@maxim.org.za>
X-OriginalArrivalTime: 22 Oct 2008 14:55:09.0940 (UTC) FILETIME=[2DF17340:01C93456]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre wrote:
> This AHB DMA Controller (aka HDMA or DMAC on AT91 systems) is
> availlable on 
> at91sam9rl chip. It will be used on other products in the future.
> 
> This first release covers only the memory-to-memory tranfer type.
> This is the 
> only tranfer type supported by this chip.
> On other products, it will be used also for peripheral DMA transfer
> (slave API 
> support to come).
> 
> I used dmatest client without problem in different configurations to
> test 
> it.
> 
> Full documentation for this controller can be found in the SAM9RL
> datasheet :
> http://www.atmel.com/dyn/products/product_card.asp?part_id=4243 
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---

Hi Nicolas,
I have walked through the code and I do not see any serious problems
here.

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
