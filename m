Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZKLXdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZKLXdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbZKLXdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:33:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:28837 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228AbZKLXdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:33:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,732,1249282800"; 
   d="scan'208";a="466853755"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "stable@kernel.org" <stable@kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 12 Nov 2009 15:32:46 -0800
Subject: RE: [stable][PATCH] PCIe hot-plug for Intel IOMMU
Thread-Topic: [stable][PATCH] PCIe hot-plug for Intel IOMMU
Thread-Index: AcpjQRKWit8peVcgTxm8zMO1o/iQVQArqGzA
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8BD5830B3@orsmsx505.amr.corp.intel.com>
References: <20091104225359.2720.91502.stgit@nehalem.aw>
	 <20091106114130J.fujita.tomonori@lab.ntt.co.jp>
	 <1257807747.25961.852.camel@macbook.infradead.org>
	 <20091111152306.GA29256@linux-os.sc.intel.com>
 <1257993435.3907.86.camel@macbook.infradead.org>
In-Reply-To: <1257993435.3907.86.camel@macbook.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nACNXa16028134

>Fenghua, please could you test what's in
>git://git.infradead.org/~dwmw2/iommu-2.6.32.git on IA64 before I send it
>to Linus? There are a couple of other fixes for HP brain damage there.

The iommu-2.6.32.git tree doesn't have problem for building, booting, and simple IOMMU testing on ia64. Since there is no environment, I don't test iommu hot-plug on ia64 (which you may not care any way).

Thanks.

-Fenghua
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
