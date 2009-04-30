Return-Path: <linux-kernel-owner+w=401wt.eu-S1761978AbZD3JQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761978AbZD3JQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 05:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbZD3JQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 05:16:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:61033 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbZD3JQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 05:16:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,271,1239001200"; 
   d="scan'208";a="408272923"
From: "Li, Jiebing" <jiebing.li@intel.com>
To: Pierre Ossman <drzeus@drzeus.cx>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Johnson, Charles F" <charles.f.johnson@intel.com>,
       "Zhu, Daniel" <daniel.zhu@intel.com>,
       "Yuan, Hang" <hang.yuan@intel.com>,
       "Pasrija, Geeta" <geeta.pasrija@intel.com>,
       "Li, Jiebing" <jiebing.li@intel.com>
Date: Thu, 30 Apr 2009 17:14:26 +0800
Subject: [PATCH 0/2] MMC: MMC/SD/CE-ATA/SDIO driver for Intel Moorestown
  platform
Thread-Topic: [PATCH 0/2] MMC: MMC/SD/CE-ATA/SDIO driver for Intel
 Moorestown  platform
Thread-Index: AcnJdA7l9tu2mvkrS8+4WTSkeCAZpA==
Message-ID: <95608CFE3D0C064B8468DB61F8403BE029D298B1F7@PDSMSX501.ccr.corp.intel.com>
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

Hi Pierre,

I wish to submit two patches for Intel low power platform "Moorestown". The below is the description of the patches:

1. Patch 1 enables CE-ATA device support on Moorestown platform.
2. Patch 2 enables SDIO OSPM suspend/resume support for SDIO devices applied on Moorestown.
3. Added some silicon/hardware specific restrictions.

This is the first time Moorestown related patches are submitted, so I'm ready for code review and will try my best to do updates before the code can be finally accepted.

Thanks a lot!

Regards,
Jiebing Li