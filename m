Return-Path: <linux-kernel-owner+w=401wt.eu-S1764365AbZLQLAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764365AbZLQLAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 06:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZLQLAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 06:00:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:43564 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbZLQLAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 06:00:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,411,1257148800"; 
   d="scan'208";a="579818192"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 17 Dec 2009 10:59:59 +0000
Subject: RE: [PATCH] dma: at_hdmac: correct incompatible type for argument 1
 of 'spin_lock_bh'
Thread-Topic: [PATCH] dma: at_hdmac: correct incompatible type for argument
 1 of 'spin_lock_bh'
Thread-Index: Acp+Z2oWA6FEZcbiRuKCqjyYkQSXSgAoAdzA
Message-ID: <129600E5E5FB004392DDC3FB599660D7CB17BB92@irsmsx504.ger.corp.intel.com>
References: <1260980883-30030-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1260980883-30030-1-git-send-email-nicolas.ferre@atmel.com>
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
> Correct a typo error in locking calls.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
