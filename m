Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbZFPLUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbZFPLUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 07:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbZFPLUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 07:20:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:25700 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164AbZFPLUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 07:20:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,228,1243839600"; 
   d="scan'208";a="466806009"
From: "Li, Jiebing" <jiebing.li@intel.com>
To: Pierre Ossman <pierre@ossman.eu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Johnson, Charles F" <charles.f.johnson@intel.com>,
       "Zhu, Daniel" <daniel.zhu@intel.com>,
       "Yuan, Hang" <hang.yuan@intel.com>
Date: Tue, 16 Jun 2009 19:18:49 +0800
Subject: [PATCH 0/1] MMC: SDIO card reset support for Intel Moorestown
  platform
Thread-Topic: [PATCH 0/1] MMC: SDIO card reset support for Intel Moorestown
  platform
Thread-Index: AcnudDjp2/h8sjeiR4yRg9sdFNfmbg==
Message-ID: <95608CFE3D0C064B8468DB61F8403BE036C19F9ECE@PDSMSX501.ccr.corp.intel.com>
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


Hi Pierre and all,

Here's a SDIO driver code patch which implements SDIO card reset support for device driver to recover the card to the normal status in case that error occurs.

Thanks for your review!


Regards,
Jiebing Li