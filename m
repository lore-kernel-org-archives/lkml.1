Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbZLOTX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbZLOTX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbZLOTX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:23:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:18275 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933354AbZLOTXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:23:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="223188686"
From: "Luck, Tony" <tony.luck@intel.com>
To: Leonardo Chiquitto <lchiquitto@novell.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Dec 2009 11:23:24 -0800
Subject: RE: [PATCH] ia64: fix SBA IOMMU to handle allocation failure
	 properly
Thread-Topic: [PATCH] ia64: fix SBA IOMMU to handle allocation failure
	 properly
Thread-Index: Acp9ckpYPsgt+P0mQrmq0llmtCdCqgASbAzA
Message-ID: <4BDB13256095B24D9644F65379E60426575FCCFB@orsmsx505.amr.corp.intel.com>
References: <20091018140631K.fujita.tomonori@lab.ntt.co.jp>
 <4B274A9A020000860004B505@novprvlin0050.provo.novell.com>
In-Reply-To: <4B274A9A020000860004B505@novprvlin0050.provo.novell.com>
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

>> This patch fixes SBA IOMMU path to handle allocation failure properly.
>
> Please, any chance to have this patch committed to 2.6.33?

Yes.  I have it batched to send today.

-Tony
