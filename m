Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbYJFTpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbYJFTpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 15:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYJFTpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 15:45:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:48049 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbYJFTpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 15:45:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,368,1220252400"; 
   d="scan'208";a="344635895"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "Luck, Tony" <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Mon, 6 Oct 2008 12:44:29 -0700
Subject: RE: [PATCH 0/2]Add Variable Page Size and IA64 Support in Intel
 IOMMU
Thread-Topic: [PATCH 0/2]Add Variable Page Size and IA64 Support in Intel
 IOMMU
Thread-Index: Acklb8Zvk1X2wFH/RvypCITWhNlMeQCe7mRw
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8844A6B45@orsmsx505.amr.corp.intel.com>
References: <20081001165606.GA21279@linux-os.sc.intel.com>
 <200810030950.19359.bjorn.helgaas@hp.com>
In-Reply-To: <200810030950.19359.bjorn.helgaas@hp.com>
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

>> The following two patches (Intel IOMMU generic patch and ia64 specific

>the fact that the DMAR table is static precludes any sort of hot-plug
>to add or remove IOMMUs.

The latest VT-d spec v1.1 does not support hot plug. If the feature is available in newer spec, we will support it.

Thanks.

-Fenghua
