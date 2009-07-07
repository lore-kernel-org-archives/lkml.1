Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbZGGPdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbZGGPdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbZGGPcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:32:52 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:4299 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbZGGPcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:32:51 -0400
X-SpamScore: 8
X-BigFish: VPS8(zzzz1202hzz92fbmz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KMF4IC-01-6TK-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: IOMMU and graphics cards
Date: Tue, 7 Jul 2009 10:33:53 -0500
Message-ID: <6453C3CB8E2B3646B0D020C11261327303FA5894@sausexmb4.amd.com>
In-Reply-To: <6453C3CB8E2B3646B0D020C11261327303FA5888@sausexmb4.amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: IOMMU and graphics cards
Thread-Index: Acn/FLG/PAUo6NcDSbK16YE1twsX2QAAIofQAAC546A=
References: <20090507164742V.fujita.tomonori@lab.ntt.co.jp><20090507100114.GF4059@amd.com><1241691721.3531.73.camel@macbook.infradead.org><20090507.113632.210373283.davem@davemloft.net><20090508093526.GB13708@8bytes.org><1246883177.2615.33.camel@macbook.infradead.org><20090706131156.GL5380@amd.com><1246889932.2615.81.camel@macbook.infradead.org><alpine.DEB.2.00.0907062232350.5769@skynet.skynet.ie><0DDD3FAD-969A-421B-A36A-77AB645E8BCA@gmail.com> <6453C3CB8E2B3646B0D020C11261327303FA5888@sausexmb4.amd.com>
From: "Duran, Leo" <leo.duran@amd.com>
To: "Dave Airlie" <airlied@gmail.com>, "Dave Airlie" <airlied@linux.ie>
CC: "Zhenyu Wang" <zhenyu.z.wang@intel.com>, <linux-kernel@vger.kernel.org>,
       <fujita.tomonori@lab.ntt.co.jp>, <eric@anholt.net>,
       <iommu@lists.linux-foundation.org>, <mingo@redhat.com>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 07 Jul 2009 15:32:42.0379 (UTC) FILETIME=[2B13DDB0:01C9FF18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the spec for the AND IOMMU (with braces):
<http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs
/34434.pdf>

HTH,
Leo.

