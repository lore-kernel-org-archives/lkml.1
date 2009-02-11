Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbZBKT3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbZBKT3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 14:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbZBKT33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 14:29:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:5442 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917AbZBKT32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 14:29:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,193,1233561600"; 
   d="scan'208";a="664806744"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Bhavesh Davda'" <bhavesh@vmware.com>,
       "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Johannes Berg'" <johannes@sipsolutions.net>,
       "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
       "Winkler, Tomas" <tomas.winkler@intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>, "'Chris Wright'" <chrisw@sous-sol.org>
CC: "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'LKML'" <linux-kernel@vger.kernel.org>
Date: Wed, 11 Feb 2009 11:29:25 -0800
Subject: RE: [PATCH]iwlan dma mapping read and write changes
Thread-Topic: [PATCH]iwlan dma mapping read and write changes
Thread-Index: AcmMd06axlaX3nZjTEykWUJ2Z4AU4AAACLxgAAHIuEA=
Message-ID: <A6AD88C3F2289247BE726C37303E1EB894CF3EE2@orsmsx505.amr.corp.intel.com>
References: <20081001165606.GA21279@linux-os.sc.intel.com>
 <20090211182648.GA1661@linux-os.sc.intel.com>
 <AF9CD7A487028E428749836D21102612201D593E65@PA-EXMBX02.vmware.com>
In-Reply-To: <AF9CD7A487028E428749836D21102612201D593E65@PA-EXMBX02.vmware.com>
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



>Looks good to me. Ship it!
>
>- Bhavesh
> 
>Bhavesh P. Davda

Reviewed-by: Bhavesh Davda <bhavesh@vmware.com>

Thanks.

-Fenghua
